import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:clipit_front/screens/result_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:clipit_front/components/rank_container.dart';
import 'package:clipit_front/models/ranking.dart';
import 'package:image/image.dart' as img;

class RankingPage extends StatefulWidget {
  final int themeId;
  final String themeName;

  const RankingPage({
    super.key,
    required this.themeId,
    required this.themeName
  });

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Ranking> ranking = [];
  bool isLoading = true;
  XFile? _selectedImage;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchRanking(widget.themeId);
  }

  // ランキングデータを取得
  Future<void> fetchRanking(int themeId) async {
    final uri = Uri.parse('https://clipit-backend.onrender.com/ranking_$themeId');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body)['results'];
        setState(() {
          ranking = body.map((json) => Ranking.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('ランキングデータの取得に失敗しました: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching rankings: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // ギャラリーから画像を選択する関数
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      setState(() {
        _selectedImage = pickedFile;
      });
      _showModal(context);
    }
  }

  // 画像アップロード
  Future<void> uploadImage() async {
    if (_selectedImage != null) {
      try {
        final File file = File(_selectedImage!.path);
      
        await compressImage(file);

        Uint8List resizedBytes = await file.readAsBytes();

        final int imageId = DateTime.now().millisecondsSinceEpoch;
        final String fileName = '$imageId.png';
        
        final ref = _storage.ref().child(fileName);
        final uploadFile = await ref.putData(
          resizedBytes,
          SettableMetadata(
                  contentType: 'application/octet-stream', // 一般的なバイナリデータとして
                ),
        );

        final String sendImageUrl = await ref.getDownloadURL();

        if (uploadFile.state == TaskState.success) {
          final imgUrl = await ref.getDownloadURL();
          debugPrint('アップロード成功: $imgUrl');

          final response = await sendImageDataToBackend(sendImageUrl, widget.themeId);
          debugPrint('response: $response');
          if (response != null) {
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  image: file,
                  serverResponse: response,
                ),
              ),
            );
          }
        } else {
          throw Exception('画像アップロード中にエラーが発生しました');
        }
      } catch (e) {
        debugPrint('エラー: $e');
      }
    }
  }


  // 画像圧縮
  Future<void> compressImage(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

    if (image == null) {
      debugPrint("画像のデコードに失敗しました");
      return ;
    }

    img.Image resizedImage = img.copyResize(image, width: 1042);
    List<int> compressedImage = img.encodeJpg(resizedImage, quality: 80);

    File compressedFile = File('${file.parent.path}/compressed_${file.uri.pathSegments.last}');
    await compressedFile.writeAsBytes(compressedImage);

    setState(() {
      file = compressedFile;
    });
  }


  // バックエンドに画像データを送信
  Future<Map<String, dynamic>?> sendImageDataToBackend(String imageUrl, int themeId) async {
  
    final uri = Uri.parse('https://clipit-backend.onrender.com/upload');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'img_url': imageUrl, 'theme_id': themeId.toString()},
      );
      debugPrint('送信データ: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('バックエンド通信中にエラーが発生しました: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('バックエンド送信エラー: $e');
      return null;
    }
  }

  // モーダルウィンドウ
  void _showModal(BuildContext context) {
    if (_selectedImage != null) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          bool isUploading = false;

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modalSetState) {
              return SizedBox(
                height: 600,
                child: Column(
                  children: [
                    // 画像のプレビュー
                    Image.file(
                      File(_selectedImage!.path),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),

                    // 結果を見るボタン
                    ElevatedButton(
                      onPressed: isUploading
                          ? null
                          : () async {
                              modalSetState(() {
                                isUploading = true; // ローディング開始
                              });

                              await uploadImage();

                              modalSetState(() {
                                isUploading = false; // ローディング終了
                              });
                            },
                      child: isUploading
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("処理中..."),
                              ],
                            )
                          : const Text("結果を見る"),
                    ),

                    // 閉じるボタン
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("閉じる"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.themeName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ranking.length,
              itemBuilder: (context, index) {
                return RankContainer(ranking: ranking[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectImage,
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}

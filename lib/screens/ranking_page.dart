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
        isScrollControlled: true,
        builder: (BuildContext context) {
          bool isUploading = false;

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modalSetState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff64C5D3),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.only(top: 70),
                
                // 白いとこ
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  
                  child: FractionallySizedBox(
                    child: Container (
                      width: double.infinity,
                      color: const Color(0xffffffff),

                      child: Column(
                        children: [
                          // 画像のプレビュー
                          const Padding(padding: EdgeInsets.symmetric(vertical: 25),),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 70,
                              minHeight: 70,
                              maxWidth: 350,
                              maxHeight: 500
                            ),
                            
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,               
                              ),
                            ),                            
                          ),
                          

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

                          // 別の画像を選ぶボタン


                          // 閉じるボタン
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("閉じる"),
                          ),
                        ],
                      ),
                    ),
                    
                  )
                  
                  )               
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
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text(
          'Select Topics',
          style: TextStyle(
            color: Color(0xffffffff),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAB800),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAB800),
      body: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: Container(
          color: Colors.white,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: ranking.length * 2 - 1,
                  itemBuilder: (context, index) {

                    // 線引く
                    if (index.isOdd) {
                    return const Divider(
                      height: 1,
                      thickness: 1,
                      // indent: 30,
                      // endIndent: 30,
                      color: Colors.grey,
                    );
                  } else {
                    int rankIndex = index ~/ 2; // 奇数のインデックスはDividerなので、偶数インデックスにランキングを設定
                    return RankContainer(ranking: ranking[rankIndex]);
                  }
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectImage,
        child: const Icon(Icons.upload_file),
      ),
    );
  }

}

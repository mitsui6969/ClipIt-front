import 'dart:convert';
import 'dart:io';
import 'package:clipit_front/screens/result_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:clipit_front/components/rank_container.dart';
import 'package:clipit_front/models/ranking.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Ranking> ranking = [];
  bool isLoading = true;
  XFile? _selectedImage;
  int themeId = 1;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchRanking(themeId);
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
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        final ref = _storage.ref().child(fileName);
        final uploadFile = await ref.putFile(file);

        if (uploadFile.state == TaskState.success) {
          final imgUrl = await ref.getDownloadURL();
          debugPrint('アップロード成功: $imgUrl');

          final response = await sendImageDataToBackend(imgUrl, themeId);
          if (response != null) {
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

  // バックエンドに画像データを送信
  Future<Map<String, dynamic>?> sendImageDataToBackend(String imageUrl, int themeId) async {
    final uri = Uri.parse('https://clipit-backend.onrender.com/upload');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image_url': imageUrl, 'theme_id': themeId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('バックエンド通信中にエラーが発生しました: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('エラー: $e');
      return null;
    }
  }

  // モーダルウィンドウ
  void _showModal(BuildContext context) {
    if (_selectedImage != null) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 600,
            child: Column(
              children: [
                Image.file(
                  File(_selectedImage!.path),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text('ファイル名: ${_selectedImage!.name}'),
                ElevatedButton(
                  onPressed: uploadImage,
                  child: const Text("結果を見る"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("閉じる"),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
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

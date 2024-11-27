import 'dart:convert';
import 'dart:io';
import 'package:clipit_front/models/uploadImage.dart';
import 'package:clipit_front/screens/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // 画像選択用
import 'package:clipit_front/components/rank_container.dart'; // カスタムコンポーネント
import 'package:clipit_front/models/ranking.dart'; // モデルクラス

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Ranking> ranking = []; // APIから取得したランキングデータ
  bool isLoading = true; // ローディング状態管理
  XFile? selectedImage; // 選択された画像を保持

  @override
  void initState() {
    super.initState();
    fetchRanking(1); // APIからテーマIDに基づくランキング情報を取得
  }

  // ランキングデータを取得
  Future<void> fetchRanking(int themeId) async {
    final uri = Uri.parse('https://clipit-backend.onrender.com/ranking_$themeId'); // APIのURL
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body)['results'];
        print("レスポンス1 body: ${response.body}");
        setState(() {
          ranking = body.map((json) => Ranking.fromJson(json)).toList();
          isLoading = false;
        });
        print("レスポンス2 body: ${response.body}");
      } else {
        throw Exception('ランキングデータの取得に失敗しました: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching rankings: $error');
    }
  }

  // ギャラリーから画像を選択する関数
  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      setState(() {
        selectedImage = pickedFile; // 選択した画像を保持
      });
      _showModal(context); // モーダルを表示
    }
  }


  // 画像アップロード
  Future<Map<String, dynamic>?> uploadImage() async {
    final uri = Uri.parse('https://clipit-backend.onrender.com/upload');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', selectedImage!.path));

    request.fields['theme_id'] = '1';

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        print(jsonDecode(responseBody.body));
        return jsonDecode(responseBody.body);
      } else {
        throw Exception('画像のアップロードに失敗しました: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('エラー: $e');
    }
    return null;
  }


  // ランキング画面
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
        onPressed: _selectImage, // ボタンを押したら画像選択を開始
        child: const Icon(Icons.upload_file),
      ),
    );
  }


  // 画像選択後のモーダルウィンドウ
  void _showModal(BuildContext context) {
    if (selectedImage != null) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 600,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.file(
                    File(selectedImage!.path), // 選択した画像を表示
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Text('ファイル名: ${selectedImage!.name}'),
                  ElevatedButton(
                    onPressed: () async {
                      final response = await uploadImage();
                      if (response != null && mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage(
                              image: File(selectedImage!.path),
                              serverResponse: response,
                            )
                          ),
                        );
                      }
                    }, 
                    child: const Text("結果を見る"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

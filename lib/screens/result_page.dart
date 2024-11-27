import 'dart:io';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final File image; // 選択した画像ファイル
  final Map<String, dynamic>? serverResponse; // サーバーのレスポンス

  const ResultPage({
    super.key,
    required this.image,
    this.serverResponse,
  });

  // Future<void> fetchResult(int themeId) async {
  //   final uri = Uri.parse('https://clipit-backend.onrender.com/ranking_$themeId'); // APIのURL
  //   try {
  //     final response = await http.get(uri);
  //     if (response.statusCode == 200) {
  //       final List<dynamic> body = jsonDecode(response.body)['results'];
  //       setState(() {
  //         ranking = body.map((json) => Ranking.fromJson(json)).toList();
  //         isLoading = false;
  //       });
  //     } else {
  //       throw Exception('ランキングデータの取得に失敗しました: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     debugPrint('Error fetching rankings: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.file(image, width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            if (serverResponse != null)
              Text('サーバーレスポンス: ${serverResponse!['message']}'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}

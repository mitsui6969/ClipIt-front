import 'dart:io';
import 'package:clipit_front/models/result.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final File image;
  final Map<String, dynamic>? serverResponse;

  const ResultPage({
    super.key,
    required this.image,
    required this.serverResponse,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Result> result = [];

  @override
  void initState() {
    super.initState();

    // サーバーレスポンスがある場合、リストを更新
    if (widget.serverResponse != null) {
      if (widget.serverResponse!['results'] != null) {
        result = (widget.serverResponse!['results'] as List<dynamic>)
            .map((json) => Result.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        result = [Result.fromJson(widget.serverResponse!)];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 画像表示
            Image.file(widget.image, width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),

            // サーバーレスポンスの表示
            if (result.isEmpty)
              const Text('サーバーレスポンスがありません'),
            if (result.isNotEmpty) ...[
              const Text('Result!'),
              for (final res in result) ...[
                Text('一致度: ${res.similarity}%'),
                Text('ランキング: ${res.rank}位'),
                const SizedBox(height: 10),
              ],
            ],

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

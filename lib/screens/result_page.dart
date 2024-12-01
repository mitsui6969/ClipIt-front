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
      // appBar: AppBar(title: const Text('Result Page')),
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text(
          '結果',
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
          width: double.infinity,
          color: const Color(0xFFffffff),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 画像表示
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 70,
                        minHeight: 70,
                        maxWidth: 350,
                        maxHeight: 400
                      ),
                            
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          widget.image,
                          fit: BoxFit.cover,               
                        ),
                      ),                            
                    ),

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
            ],
          ),
        ),
      ),
    );
  }
}

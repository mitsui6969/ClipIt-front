import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class SelectTopicsPage extends StatelessWidget {
  const SelectTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Topics'),
      ),
      body: Column(
        children: [
           // 検索ボックス
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              hintText: '検索ワードを入力してください',
            ),
            onSubmitted: (String value) async {
            },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  String _data = "データがありません";

  // 初期データを取得する関数
  Future<void> fetchInitialData() async {
    final url = Uri.parse("http://127.0.0.1:8000/");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _data = responseData["message"];
        });
      } else {
        setState(() {
          _data = "データ取得に失敗しました";
        });
      }
    } catch (error) {
      setState(() {
        _data = "エラーが発生しました: $error";
      });
    }
  }

  // アイテムデータを取得する関数
  Future<void> fetchItemData() async {
    final url = Uri.parse("http://127.0.0.1:8000/items/1");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _data = "Item ID: ${responseData["item_id"]}";
        });
      } else {
        setState(() {
          _data = "アイテムデータの取得に失敗しました";
        });
      }
    } catch (error) {
      setState(() {
        _data = "エラーが発生しました: $error";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 初回表示時にデータを取得
    fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Data Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _data,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchItemData,
              child: const Text("APIからデータを取得"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // 画像選択用

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

  XFile? selectedImage; // 選択された画像を保持

  @override
  void initState() {
    super.initState();
    fetchRanking(1); // 例としてtheme_id = 1を指定
  }

  // ギャラリーから画像を選択する関数
  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile; // 選択した画像を保持
      });
      _showModal(context); // モーダルを表示
    }
  }

  Future<void> fetchRanking(int themeId) async {
    final uri = Uri.parse('https://clipit-backend.onrender.com/ranking_1'); // APIのURLに合わせる
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body)['results'];
        setState(() {
          ranking = body.map((json) => Ranking.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load rankings');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching rankings: $error');
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
        onPressed: _selectImage, // ボタンを押したら画像選択を開始
        child: const Icon(Icons.upload_file),
      ),
    );
  }

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

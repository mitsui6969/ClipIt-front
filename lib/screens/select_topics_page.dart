import 'package:clipit_front/components/topic_container.dart';
import 'package:clipit_front/models/topic.dart';
import 'package:clipit_front/screens/ranking_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectTopicsPage extends StatefulWidget {
  const SelectTopicsPage({super.key});

  @override
  State<SelectTopicsPage> createState() => _SelectTopicsPageState();
}

class _SelectTopicsPageState extends State<SelectTopicsPage> {
  List<Topic> topics = [];
  List<Topic> filteredTopics = []; // 検索用
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  // お題データを取得
  Future<void> fetchTopics() async {
    final uri = Uri.parse('https://clipit-backend.onrender.com/theme');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> body = jsonDecode(decodedResponse)['results'];
        debugPrint('response body: ${response.body}');
        setState(() {
          topics = body.map((json) => Topic.fromJson(json)).toList();
          filteredTopics = topics;
          isLoading = false;
        });
      } else {
        throw Exception('お題データの取得に失敗しました: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetchingTopics: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 検索処理
  void searchTopics(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredTopics = topics;
      } else {
        filteredTopics = topics
          .where((topic) => topic.theme_name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // title
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text('Select Topics'),
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
          color: const Color(0xFFffffff),
          child: Column(
            children: [
              // 検索ボックス
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 36,
                ),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                decoration: const InputDecoration(
                  hintText: 'keyword...',
                ),
                onSubmitted: (String value) async {
                  searchTopics(value);
                },
                ),
              ),

              // お題情報
              Expanded (
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredTopics.isEmpty
                      ? const Center(child: Text('お題が見つかりませんでした'),)
                      : ListView.builder(
                        itemCount: filteredTopics.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                    RankingPage(
                                      themeId: filteredTopics[index].theme_id,
                                      themeName: filteredTopics[index].theme_name
                                    ),
                                )
                              );
                            },
                            child: TopicContainer(
                              topic: filteredTopics[index],
                            ),
                          );
                        },
                      ),
              ),
            ],        
          ),
        )
        
    ));
  }
}

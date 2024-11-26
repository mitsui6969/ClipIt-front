import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    fetchRanking(1); // 例としてtheme_id = 1を指定
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
    );
  }
}

import 'dart:convert';
import 'package:clipit_front/components/rank_container.dart';
import 'package:clipit_front/models/ranking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RankingPage extends StatefulWidget {
  const RankingPage({
    super.key,
    required this.ranking,
  });

  final Ranking ranking;

  @override
  State<RankingPage> createState() => _RankingPageState();
}


class _RankingPageState extends State<RankingPage> {
  var _data = [];

  @override
  void initState() {
    super.initState();
    // 初回表示時にデータを取得
    fetchRaning(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
      ),
      body: Column(
        children: [
          const Text('Ranking Page', style: TextStyle(fontSize: 24)),
          RankContainer(
            ranking: Ranking(
              rank: 1,
              similarity: 30.3,
              image_url: 'https://www.google.com/imgres?q=%E3%82%B4%E3%83%AA%E3%83%A9&imgurl=https%3A%2F%2Fapp.helloohana.co.jp%2Fwp-content%2Fuploads%2F2023%2F10%2F65D037DB-C1E9-474E-9C49-EE7164622313.jpg&imgrefurl=https%3A%2F%2Fapp.helloohana.co.jp%2Fblog-1%2F&docid=nesSlaefLYEEYM&tbnid=SccMg7vpXzegmM&vet=12ahUKEwjD6uD4zPqJAxWjslYBHYl5CBUQM3oECBsQAA..i&w=1440&h=960&hcb=2&ved=2ahUKEwjD6uD4zPqJAxWjslYBHYl5CBUQM3oECBsQAA',
              theme_name: 'theme-name',
            )
          )
        ],
      ),
    );
  }

  // ランキング取得
  // Future<List<Ranking>> fetchRaning(int theme_id) async {
  //   final uri = Uri.https('clipit-backend.onrender.com', '/ranking', {
  //     'query': 'theme_id:$theme_id'
  //   });
  //   final String token = dotenv.env['ACCESS_TOKEN'] ?? '';

  //   final http.Response res = await http.get(uri, headers:{
  //     'Authorization': 'Bearer $token',
  //   });

  //   if (res.statusCode == 200){
  //     // レスポンスをモデルクラスへ変換
  //     final List<dynamic> body = jsonDecode(res.body);
  //     return body.map((dynamic json) => Ranking.fromJson(json).toList());
  //   } else {
  //     return [];
  //   }
  // }

  Future<List<Ranking>> fetchRaning(int theme_id) async {
    final uri = Uri.parse('https://clipit-backend.onrender.com/ranking_$theme_id');

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final responseData = json.decode(res.body);
        final List<dynamic> body = jsonDecode(res.body);
        setState(() {
          _data = responseData["results"];
        });
        return body.map((dynamic json) => Ranking.fromJson(json)).toList();
      } else {
        return [];
      };
    } catch (error) {
      return [];
    }
  }
}

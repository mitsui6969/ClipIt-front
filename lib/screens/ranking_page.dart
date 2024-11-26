import 'package:clipit_front/components/rank_container.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({
    super.key,
    required 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
      ),
      body: const Column(
        children: [
          Text('Ranking Page', style: TextStyle(fontSize: 24)),
          RankContainer(
            
          )
        ],
      ),
    );
  }
}

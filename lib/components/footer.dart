import 'package:clipit_front/models/ranking.dart';
import 'package:flutter/material.dart';
import 'package:clipit_front/screens/ranking_page.dart';
import 'package:clipit_front/screens/result_page.dart';
import 'package:clipit_front/screens/select_topics_page.dart';
import 'package:clipit_front/screens/show_message.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  final defaultRanking = Ranking(
    rank: 1,
    similarity: 50.5,
    image_url: '',
    theme_name: 'default theme'
  );

  // 画面リスト
  late final List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    _pages = [
      const SelectTopicsPage(),
      RankingPage(ranking: defaultRanking),
      const ResultPage(),
      const TitleScreen(),
  ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.topic),
            label: 'Topics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Result',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

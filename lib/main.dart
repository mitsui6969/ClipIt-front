import 'package:flutter/material.dart';
import 'package:clipit_front/components/footer.dart';
import 'package:clipit_front/screens/ranking_page.dart';
import 'package:clipit_front/screens/result_page.dart';
import 'package:clipit_front/screens/select_topics_page.dart';
import 'package:clipit_front/screens/show_message.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Footer();
  }
}

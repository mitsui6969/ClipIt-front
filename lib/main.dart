import 'package:flutter/material.dart';
import 'package:clipit_front/components/footer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  runApp(const ClipItApp());
}

class ClipItApp extends StatelessWidget {
  const ClipItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipIt',
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

import 'package:clipit_front/firebase_options.dart';
import 'package:clipit_front/screens/select_topics_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
      home: const SelectTopicsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';

class SelectTopicsPage extends StatelessWidget {
  const SelectTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Topics'),
      ),
      body: const Center(
        child: Text('Select Topics Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

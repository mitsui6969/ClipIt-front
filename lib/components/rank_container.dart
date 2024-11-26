import 'package:flutter/material.dart';

class RankContainer extends StatelessWidget {
  const RankContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 20,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF55C500),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Text("rank"),
                Text("一致度")
              ],
            ),
            // 画像部分
            Container(
              height: 170,
              // padding: const EdgeInsets.symmetric(
              //   vertical: 80,
              // ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 109, 232, 218),
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
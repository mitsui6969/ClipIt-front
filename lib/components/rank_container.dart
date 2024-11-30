import 'package:clipit_front/models/ranking.dart';
import 'package:flutter/material.dart';

class RankContainer extends StatelessWidget {
  const RankContainer({
    super.key,
    required this.ranking,
  });

  final Ranking ranking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: Container(
        height: 250,
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 20,
        ),
        decoration: const BoxDecoration(
          // color: Color(0xFF6cb1c9),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${ranking.rank}位",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000)
                  ),
                ),
                Text(
                  "一致度: ${ranking.similarity}%",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000)
                  ),
                )
              ],
            ),
            // 画像部分
            Container(
              height: 180,
              padding: const EdgeInsets.symmetric(
                vertical: 80,
              ),
              decoration: BoxDecoration(
                // color: const Color(0xffffffff),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5)
                ),
                image: DecorationImage(
                  image: ranking.img_url?.isNotEmpty ?? false
                      ? NetworkImage(ranking.img_url!)
                      : const AssetImage('images/image.png') as ImageProvider,
                  fit: BoxFit.cover,
                  onError: (error, StackTraces) {
                    // print("Error loading image: $error");
                  }
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
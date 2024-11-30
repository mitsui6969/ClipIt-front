import 'package:clipit_front/models/topic.dart';
import 'package:flutter/material.dart';

class TopicContainer extends StatelessWidget {
  const TopicContainer ({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 30,
      ),
      child: Container(
        height: 230,
        decoration: const BoxDecoration(
          color: Color(0xFFFAB800),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // お題
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15
              ),
              decoration: const BoxDecoration(
                // color: Color(0xFFFAB800),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
              ),
              child: Text(topic.theme_name),
            ),
            
            // 画像部分
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(
                // vertical: 15,
                horizontal: 10,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10)
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Image.network(
                  topic.image_url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'images/image.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.2),
                      colorBlendMode: BlendMode.darken,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
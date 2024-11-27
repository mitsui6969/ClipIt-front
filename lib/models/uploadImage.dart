import 'dart:io';

class Uploadimage {
  // コンストラクタ
  Uploadimage({
    required this.img_data,
    required this.theme_id,
  });

  // プロパティ
  final File img_data;
  final int theme_id;

  // JSON生成するファクトリコンストラクタ
  Map<String, dynamic> toJson() => {
    'img_data': img_data,
    'theme_id': theme_id,
  };
}
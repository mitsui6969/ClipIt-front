class Uploadimage {
  // コンストラクタ
  Uploadimage({
    required this.image_id,
    required this.theme_id,
  });

  // プロパティ
  final int image_id;
  final int theme_id;

  // JSON生成するファクトリコンストラクタ
  Map<String, dynamic> toJson() => {
    'img_data': image_id,
    'theme_id': theme_id,
  };
}
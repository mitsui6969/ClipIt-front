class Uploadimage {
  // コンストラクタ
  Uploadimage({
    required this.image_url,
    required this.theme_id,
  });

  // プロパティ
  final int image_url;
  final int theme_id;

  // JSON生成するファクトリコンストラクタ
  Map<String, dynamic> toJson() => {
    'img_data': image_url,
    'theme_id': theme_id,
  };
}

class Topic {
  // コンストラクタ
  Topic({
    required this.rank,
    required this.theme_id,
    required this.theme_name,
    required this.similarity,
    required this.img_url,
  });

  // プロパティ
  final int rank;
  final int theme_id;
  final String theme_name;
  final double similarity;
  final String img_url;

  // JSONからRankingを生成するファクトリコンストラクタ
  factory Topic.fromJson(dynamic json) {
    return Topic(
      rank: json['rank'] as int? ?? 0,
      theme_id: json['theme_id'] as int? ?? 0,
      theme_name: json['theme_name'] is String && json['theme_name'] != null
          ? json['theme_name']
          : 'Unknown',
      similarity: json['similarity'] is double
          ? json['similarity']
          : (json['similarity'] is int
              ? (json['similarity'] as int).toDouble()
              : 0.0),
      img_url: json['img_url'] != null && json['img_url'] is String
          ? json['img_url']
          : '', // デフォルト値として空文字列を設定
    );
  }
}
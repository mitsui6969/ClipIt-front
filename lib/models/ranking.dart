
class Ranking {
  // コンストラクタ
  Ranking({
    required this.similarity,
    required this.rank,
    required this.img_url,
    // required this.image_id,
    required this.theme_name,
    required this.theme_id,
  });

  // プロパティ
  final double similarity;
  final int rank;
  final String? img_url;
  // final int image_id;
  final String theme_name;
  final int theme_id;

  // JSONからRankingを生成するファクトリコンストラクタ
  factory Ranking.fromJson(dynamic json) {
    return Ranking(
      similarity: json['similarity'] is double
          ? json['similarity']
          : (json['similarity'] is int
              ? (json['similarity'] as int).toDouble()
              : 0.0),
      rank: json['rank'] as int? ?? 0,
      img_url: json['image_url'] != null && json['image_url'] is String && (json['image_url'] as String).isNotEmpty
        ? json['image_url']
        : '',
      theme_name: json['theme_name'] as String? ?? 'Unknown',
      theme_id: json['theme_id'] as int? ?? 0,
    );
  }
}
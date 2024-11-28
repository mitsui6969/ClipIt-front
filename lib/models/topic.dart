
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
  factory Topic.fromJson(dynamic json){
    return Topic(
      rank: json['rank'] as int,
      theme_id: json['theme_id'] as int,
      theme_name: json['theme_name'] as String,
      similarity: json['similarity'] as double,
      img_url: json['img_url'] as String,
    );
  }
}
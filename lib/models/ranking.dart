
class Ranking {
  // コンストラクタ
  Ranking({
    required this.similarity,
    required this.rank,
    required this.image_url,
    required this.theme_name,
  });

  // プロパティ
  final double similarity;
  final int rank;
  final String image_url;
  final String theme_name;

  // JSONからRankingを生成するファクトリコンストラクタ
  factory Ranking.fromJson(dynamic json){
    return Ranking(
      similarity: json['similarity'] as double,
      rank: json['rank'] as int,
      image_url: json['image-url'] as String,
      theme_name: json['theme_name'] as String,
    );
  }
}
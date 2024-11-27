
class Ranking {
  // コンストラクタ
  Ranking({
    required this.similarity,
    required this.rank,
    required this.img_url,
    // required this.image_id,
    required this.theme_name,
  });

  // プロパティ
  final double similarity;
  final int rank;
  final String? img_url;
  // final int image_id;
  final String theme_name;

  // JSONからRankingを生成するファクトリコンストラクタ
  factory Ranking.fromJson(dynamic json){
    return Ranking(
      similarity: json['similarity'] as double,
      rank: json['rank'] as int,
      img_url: json['img-url'] as String?,
      // image_id: json['img_id'] as int,
      theme_name: json['theme_name'] as String,
    );
  }
}
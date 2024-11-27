
class Result {
  // コンストラクタ
  Result({
    required this.similarity,
    required this.rank,
  });

  // プロパティ
  final double similarity;
  final int rank;

  // JSONからResultを生成するファクトリコンストラクタ
  factory Result.fromJson(dynamic json){
    return Result(
      similarity: json['similarity'] as double,
      rank: json['rank'] as int,
    );
  }
}

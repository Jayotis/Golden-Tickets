
class GameDrawData {
  final int id;
  final String game;
  final int combinationsTotalChosen;
  final int totalGameDrawCombinations;
  final int combinationsTotalGenerated;
  final String drawDate;

  GameDrawData({
    required this.id,
    required this.game,
    required this.combinationsTotalChosen,
    required this.totalGameDrawCombinations,
    required this.combinationsTotalGenerated,
    required this.drawDate,
  });

  factory GameDrawData.fromJson(Map<String, dynamic> json) {
    return GameDrawData(
      id: int.parse(json['id']),
      game: json['game'] as String,
      combinationsTotalChosen: json['combinations_total_chosen'] as int,
      totalGameDrawCombinations: json['total_game_draw_combinations'] as int,
      combinationsTotalGenerated: json['combinations_total_generated'] as int,
      drawDate: json['draw_date'] as String,
    );
  }

}
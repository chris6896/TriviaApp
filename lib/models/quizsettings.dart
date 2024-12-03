class QuizSettings {
  int numberOfQuestions;
  String? category;
  String? difficulty;
  String? type;

  QuizSettings({
    required this.numberOfQuestions,
    this.category,
    this.difficulty,
    this.type,
  });
}

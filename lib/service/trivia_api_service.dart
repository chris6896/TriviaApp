import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class TriviaAPIService {
  static const String _baseUrl = "https://opentdb.com/api.php";

  Future<List<Question>> fetchQuestions({
    required int amount,
    String? category,
    String? difficulty,
    String? type,
  }) async {
    String url = '$_baseUrl?amount=$amount';
    if (category != null && category.isNotEmpty) url += '&category=$category';
    if (difficulty != null && difficulty.isNotEmpty) url += '&difficulty=$difficulty';
    if (type != null && type.isNotEmpty) url += '&type=$type';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'] as List;
      return data.map((q) => Question.fromJson(q)).toList();
    } else {
      throw Exception("Failed to load questions");
    }
  }
}

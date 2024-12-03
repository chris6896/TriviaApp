import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class ApiService {
  static Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['trivia_categories'];
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  static String _cleanText(String text) {
    return text
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', "&")
        .replaceAll('&lt;', "<")
        .replaceAll('&gt;', ">");
  }

  static Future<List<Question>> fetchQuestions(
    int numQuestions,
    String? category,
    String difficulty,
    String type,
  ) async {
    final url = 'https://opentdb.com/api.php?amount=$numQuestions'
        '${category != null ? '&category=$category' : ''}'
        '&difficulty=$difficulty'
        '&type=$type';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      return data.map<Question>((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch questions');
    }
  }
}

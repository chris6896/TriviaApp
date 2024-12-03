import 'package:flutter/material.dart';
import '../models/question.dart';
import '../service/trivia_api_service.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _apiService = ApiService();
  int _amount = 10;
  String? _selectedCategory;
  String? _difficulty;
  String? _type;
  List<dynamic> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch categories: $e")),
      );
    }
  }

  Future<void> _startQuiz() async {
    try {
      final questions = await ApiService.fetchQuestions(
        _amount,
        _selectedCategory,
        _difficulty?.toLowerCase() ?? "easy",
        _type?.toLowerCase() ?? "multiple",
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(questions: questions),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch questions: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setup Quiz")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButton<int>(
                    value: _amount,
                    onChanged: (value) => setState(() => _amount = value!),
                    items: [5, 10, 15]
                        .map((e) => DropdownMenuItem(value: e, child: Text("$e Questions")))
                        .toList(),
                  ),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (value) => setState(() => _selectedCategory = value),
                    items: _categories
                        .map((category) => DropdownMenuItem(
                              value: category['id'].toString(),
                              child: Text(category['name']),
                            ))
                        .toList(),
                  ),
                  DropdownButton<String>(
                    value: _difficulty,
                    onChanged: (value) => setState(() => _difficulty = value),
                    items: ["Easy", "Medium", "Hard"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                  DropdownButton<String>(
                    value: _type,
                    onChanged: (value) => setState(() => _type = value),
                    items: ["Multiple", "True/False"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                  ElevatedButton(
                    onPressed: _startQuiz,
                    child: Text("Start Quiz"),
                  ),
                ],
              ),
            ),
    );
  }
}

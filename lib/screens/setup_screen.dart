import 'package:flutter/material.dart';
import 'package:flutter_application_25/service/trivia_api_service.dart';
import '../models/quizsettings.dart';
import '../service/trivia_api_service.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _apiService = TriviaAPIService();
  int _amount = 10;
  String? _selectedCategory;
  String? _difficulty;
  String? _type;

  Future<void> _startQuiz() async {
    try {
      final questions = await _apiService.fetchQuestions(
        amount: _amount,
        category: _selectedCategory,
        difficulty: _difficulty,
        type: _type,
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
      body: Padding(
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
            // Replace with dynamic API category fetching
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (value) => setState(() => _selectedCategory = value),
              items: [
                DropdownMenuItem(value: "9", child: Text("General Knowledge")),
                DropdownMenuItem(value: "21", child: Text("Sports")),
              ],
            ),
            DropdownButton<String>(
              value: _difficulty,
              onChanged: (value) => setState(() => _difficulty = value),
              items: ["easy", "medium", "hard"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            DropdownButton<String>(
              value: _type,
              onChanged: (value) => setState(() => _type = value),
              items: ["multiple", "boolean"]
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

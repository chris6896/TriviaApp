import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback replayQuiz;

  SummaryScreen({
    required this.score,
    required this.totalQuestions,
    required this.replayQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Summary")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Score: $score / $totalQuestions",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: replayQuiz,
                child: Text("Replay Quiz"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Back to Setup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

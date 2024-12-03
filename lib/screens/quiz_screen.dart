import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import 'summary_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;

  QuizScreen({required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  Timer? _timer;
  int _timeLeft = 15;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Time's Up! The correct answer is: ${widget.questions[_currentIndex].correctAnswer}"),
        duration: Duration(seconds: 3),
      ),
    );
    _nextQuestion();
  }

  void _answerQuestion(String selectedAnswer) {
    final question = widget.questions[_currentIndex];
    final isCorrect = selectedAnswer == question.correctAnswer;

    setState(() {
      if (isCorrect) {
        _score++;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCorrect ? 'Correct!' : 'Wrong! The correct answer is: ${question.correctAnswer}'),
          duration: Duration(seconds: 2),
        ),
      );
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _startTimer();
    } else {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryScreen(
            score: _score,
            totalQuestions: widget.questions.length,
            replayQuiz: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(questions: widget.questions),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz (${_currentIndex + 1}/${widget.questions.length})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time Left: $_timeLeft seconds",
              style: TextStyle(fontSize: 18.0, color: Colors.red),
            ),
            SizedBox(height: 16.0),
            Text(
              question.question,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ...question.options.map((option) {
              return ElevatedButton(
                onPressed: () => _answerQuestion(option),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

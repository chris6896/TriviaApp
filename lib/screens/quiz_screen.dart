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
  bool _isAnswered = false;
  Timer? _timer;
  int _timeLeft = 15;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _onTimeUp();
        }
      });
    });
  }

  void _onTimeUp() {
    _isAnswered = true;
    _timer?.cancel();
    _nextQuestion();
  }

  void _answerQuestion(String answer) {
    if (_isAnswered) return;
    _isAnswered = true;
    if (answer == widget.questions[_currentIndex].correctAnswer) {
      _score++;
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    Future.delayed(Duration(seconds: 2), () {
      if (_currentIndex < widget.questions.length - 1) {
        setState(() {
          _currentIndex++;
          _isAnswered = false;
          _startTimer();
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryScreen(score: _score, questions: widget.questions),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      body: Column(
        children: [
          Text("Time Left: $_timeLeft seconds"),
          Text("Question ${_currentIndex + 1} of ${widget.questions.length}"),
          Text(question.question),
          ...question.options.map((option) => ElevatedButton(
                onPressed: () => _answerQuestion(option),
                child: Text(option),
              )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';

void main() {
  runApp(TriviaApp());
}

class TriviaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia',
      home: SetupScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'quiz_screen.dart'; // Import QuizScreen from another file

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(),
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 255, 158, 12),
        hintColor: const Color.fromARGB(255, 24, 230, 31),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

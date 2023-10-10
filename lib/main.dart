import 'package:flutter/material.dart';
import 'dart:math';

import 'get_countries.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(),
      theme: ThemeData(
        primaryColor:
            Color.fromARGB(255, 255, 158, 12), // Change the primary color
        hintColor:
            const Color.fromARGB(255, 24, 230, 31), // Change the accent color
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, String>> countries = countries_map();
  int score = 0;

  int currentQuestionIndex = 0;
  bool isAnswered = false;
  bool isCorrect = false;

  List<Map<String, String>> currentQuestionOptions = [];

  void generateRandomQuestion() {
    currentQuestionOptions.clear();

    while (currentQuestionOptions.length < 4) {
      final randomIndex = Random().nextInt(countries.length);
      final randomCountry = countries[randomIndex];
      if (!currentQuestionOptions.contains(randomCountry)) {
        currentQuestionOptions.add(randomCountry);
      }
    }

    final correctCountryIndex = Random().nextInt(4);
    currentQuestionOptions[correctCountryIndex]['isCorrect'] = 'true';
    for (final option in currentQuestionOptions) {
      if (option['isCorrect'] == 'true') continue;
      option['isCorrect'] = 'false';
    }
    setState(() {
      currentQuestionIndex = correctCountryIndex;
      isAnswered = false;
    });
  }

  void checkAnswer(String selectedCountry) {
    if (!isAnswered) {
      for (final option in currentQuestionOptions) {
        if (option['name'] == selectedCountry) {
          if (option['isCorrect'] == 'true') {
            isCorrect = true;
          } else {
            isCorrect = false;
          }
        }
      }
      debugPrint(currentQuestionOptions[currentQuestionIndex]['isCorrect']);
      debugPrint(currentQuestionOptions.toString());
      if (isCorrect) {
        setState(() {
          score += 1; // Increment the score by 1 for correct answers
        });
      } else {
        setState(() {
          score -= 1;
        });
      }
      setState(() {
        isAnswered = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    generateRandomQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Guess the Country',
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Image.network(
              currentQuestionOptions[currentQuestionIndex]['flag']!,
              height: 200.0,
              width: 300.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 50.0),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.0,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: currentQuestionOptions.length,
              itemBuilder: (context, index) {
                final country = currentQuestionOptions[index];
                return ElevatedButton(
                  onPressed: () => checkAnswer(country['name']!),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20), // Adjust padding as needed
                    backgroundColor:
                        isAnswered && country['isCorrect'] == 'true'
                            ? isCorrect
                                ? Color.fromARGB(255, 29, 217, 35)
                                : Color.fromRGBO(225, 23, 9, 1)
                            : Colors.purple[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Adjust the radius as needed
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown, // Scale down the text to fit
                    child: Text(
                      country['name']!,
                      style: TextStyle(
                        fontSize: 20.0, // Adjust font size as needed
                        color: Colors.black, // Text color
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () => generateRandomQuestion(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      30.0), // Adjust the radius as needed
                ),
              ),
              child: Text(
                isAnswered ? 'Next Question' : 'Skip',
                style: TextStyle(color: Colors.black),
              ),
            ),

            SizedBox(height: 16.0),
            Text('Score: $score',
                style: TextStyle(fontSize: 20.0)), // Display the score
          ],
        ),
      ),
    );
  }
}

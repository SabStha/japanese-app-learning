import 'package:flutter/material.dart';
import 'flashcards.dart';

class LessonsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lessons")),
      body: Center(
        child: ElevatedButton(
          child: Text("Start Flashcards"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FlashcardScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

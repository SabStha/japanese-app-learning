import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LearningPathScreen extends StatefulWidget {
  @override
  _LearningPathScreenState createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  String userId = "test_user"; // Replace with real authentication ID
  String selectedPath = ""; // Store selected path

  void updateLearningPath(String path) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_progress')
          .doc(userId)
          .update({"learning_path": path});

      setState(() {
        selectedPath = path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Learning Path Updated to: $path")),
      );
    } catch (e) {
      print("❌ Error updating learning path: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Learning Path")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Choose Your Learning Path",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // JLPT Path
            ElevatedButton(
              onPressed: () => updateLearningPath("JLPT Preparation"),
              child: Text("JLPT Preparation"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 10),

            // Travel Path
            ElevatedButton(
              onPressed: () => updateLearningPath("Travel Japanese"),
              child: Text("Travel Japanese"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 10),

            // Anime Phrases Path
            ElevatedButton(
              onPressed: () => updateLearningPath("Anime Phrases"),
              child: Text("Anime Phrases"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 10),

            // Others Path
            ElevatedButton(
              onPressed: () => updateLearningPath("Other Learning"),
              child: Text("Other Learning"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

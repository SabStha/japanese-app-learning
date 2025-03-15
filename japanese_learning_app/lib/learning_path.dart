import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LearningPathScreen extends StatefulWidget {
  @override
  _LearningPathScreenState createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  String userId = "test_user"; // Replace with actual user ID when authentication is added
  String selectedPath = ""; // Stores selected learning path

  void updateLearningPath(String path) async {
    try {
      await FirebaseFirestore.instance.collection('user_progress').doc(userId).update({
        "learning_path": path
      });

      setState(() {
        selectedPath = path;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("✅ Learning Path Updated: $path"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("❌ Error updating learning path: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Learning Path")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Choose a learning path:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),

            buildPathButton("JLPT N5-N1"),
            buildPathButton("Travel Japanese"),
            buildPathButton("Anime Phrases"),
            buildPathButton("Custom Path"),
          ],
        ),
      ),
    );
  }

  Widget buildPathButton(String path) {
    return ElevatedButton(
      onPressed: () => updateLearningPath(path),
      child: Text(path),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedPath == path ? Colors.blue : Colors.grey.shade300,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),

            // Welcome Message & Streak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("こんにちは, User!", 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("Streak: 🔥 5 Days", 
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
                Icon(Icons.notifications, size: 30, color: Colors.grey),
              ],
            ),

            SizedBox(height: 30),

            // Daily Kanji Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text("今日の漢字 (Today's Kanji)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("日", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("ひ (hi) - Sun / Day", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            SizedBox(height: 30),

            // XP Progress Bar
            Text("XP Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.6,  // Example progress (60%)
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
              minHeight: 8,
            ),
            SizedBox(height: 5),
            Text("600 XP / 1000 XP to Level Up", style: TextStyle(fontSize: 16, color: Colors.grey)),

            SizedBox(height: 30),

            // Mascot Reaction
            Center(
              child: Column(
                children: [
                  Image.asset("assets/mascot_happy.png", width: 120), // Mascot Image
                  SizedBox(height: 10),
                  Text("Great job! Keep up your streak! 🎉",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int xp = 0; // Stores user's XP
  int level = 1; // Stores user's level
  int streak = 0; // Stores user's streak progress
  String userId = "test_user"; // Replace with actual user ID when authentication is added
  List<String> rewards = []; // Stores user rewards


  @override
  void initState() {
    super.initState();
    fetchXP(); // Fetch XP & Streak when screen loads
  }

  void fetchXP() async {
  String userId = "test_user"; // Replace with real user ID

  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('user_progress').doc(userId).get();

  if (snapshot.exists) {
    final data = snapshot.data() as Map<String, dynamic>?;

    setState(() {
      xp = data?["xp"] ?? 0;
      streak = data?["streak"] ?? 0;
      level = data?["level"] ?? 1;
      List<String> newRewards = List<String>.from(data?["rewards"] ?? []);

        if (newRewards.length > rewards.length) {
        setState(() {
            rewards = newRewards;
        });
        showRewardsDialog(); // ✅ Show the pop-up if new rewards are added
        }

    });
  }
  print("✅ Fetched XP: $xp | Streak: $streak | Level: $level | Rewards: $rewards");
}

void showRewardsDialog() {
  if (rewards.isNotEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("🎁 Rewards Earned!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: rewards.map((reward) => Text(reward)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}





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
                    Text("こんにちは, User! (Level $level)", 
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                    Text("Streak: 🔥 $streak Days", 
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
              value: xp / 1000, // Progress is calculated dynamically
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
              minHeight: 8,
            ),
            SizedBox(height: 5),
            Text("$xp XP / 1000 XP to Level Up", style: TextStyle(fontSize: 16, color: Colors.grey)),

            SizedBox(height: 30),

            // Mascot Reaction
            Center(
              child: Column(
                children: [
                  Image.asset("assets/mascot_happy.png", width: 120), // Mascot Image
                  SizedBox(height: 10),
                  Text(
                    xp == 0 && level > 1 ? "🎉 You Leveled Up to Level $level!" : "Great job! Keep up your streak! 🎉",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'learning_path_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int xp = 0; 
  int level = 1; 
  int streak = 0; 
  String userId = "test_user"; 
  String learningPath = "Not Selected"; // Stores user’s learning path
  List<String> unlockedFeatures = []; // ✅ Add this missing variable
  List<String> earnedBadges = []; // ✅ Add this missing variable
  
  @override
  void initState() {
    super.initState();
    fetchXP();
    fetchUserData(); // Fetch user XP, streak, level, and learning path
    
  }
  

  void fetchUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('user_progress').doc(userId).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;

        setState(() {
          xp = data?["xp"] ?? 0;
          streak = data?["streak"] ?? 0;
          level = data?["level"] ?? 1;
          learningPath = data?["learning_path"] ?? "Not Selected";
        });

        print("✅ XP: $xp | Streak: $streak | Level: $level | Learning Path: $learningPath");
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
    }
  }

  void fetchXP() {
    FirebaseFirestore.instance
        .collection('user_progress')
        .doc(userId)
        .snapshots() // ✅ Listen for real-time updates
        .listen((snapshot) {
        if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;

        setState(() {
            xp = data?["xp"] ?? 0;
            streak = data?["streak"] ?? 0;
            level = data?["level"] ?? 1;
            unlockedFeatures = List<String>.from(data?["unlocked_features"] ?? []);
            earnedBadges = List<String>.from(data?["badges"] ?? []);
            learningPath = data?["learning_path"] ?? "Not Set"; // ✅ Update learning path instantly
        });

        print("✅ XP: $xp | Streak: $streak | Level: $level | Learning Path: $learningPath");
        }
    });
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

            /// ✅ Display User Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "こんにちは, User! (Level $level)",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Streak: 🔥 $streak Days",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      "📖 Learning Path: $learningPath",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(Icons.notifications, size: 30, color: Colors.grey),
              ],
            ),

            SizedBox(height: 30),

            /// ✅ Daily Kanji Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    "今日の漢字 (Today's Kanji)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("日", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("ひ (hi) - Sun / Day", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            SizedBox(height: 30),

            /// ✅ XP Progress Bar
            Text("XP Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: xp / 1000, // Dynamic XP bar progress
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
              minHeight: 8,
            ),
            SizedBox(height: 5),
            Text(
              "$xp XP / 1000 XP to Level Up",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            SizedBox(height: 30),

            /// ✅ Learning Path-Specific Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearningPathScreen()),
                  );
                },
                child: Text("Change Learning Path"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

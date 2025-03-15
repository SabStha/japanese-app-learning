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
  List<String> unlockedFeatures = []; // Stores unlocked features
  List<String> earnedBadges = []; // Stores user's earned badges

  @override
  void initState() {
    super.initState();
    fetchXP(); // Fetch XP & Streak when screen loads
  }


  void checkForNewBadges() async {
    try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(userId)
            .get();

        if (!snapshot.exists) return; // Stop if no data

        final data = snapshot.data() as Map<String, dynamic>?;

        List<String> currentBadges = List<String>.from(data?["badges"] ?? []);
        List<String> newBadges = [];

        // 🔥 Streak Badges
        if (streak >= 5 && !currentBadges.contains("🔥 5-Day Streak")) newBadges.add("🔥 5-Day Streak");
        if (streak >= 10 && !currentBadges.contains("🔥 10-Day Streak")) newBadges.add("🔥 10-Day Streak");
        if (streak >= 30 && !currentBadges.contains("🔥 30-Day Streak")) newBadges.add("🔥 30-Day Streak");

        // 🎓 XP-Based Learning Badges
        if (xp >= 1000 && !currentBadges.contains("📚 First 1000 XP")) newBadges.add("📚 First 1000 XP");
        if (xp >= 5000 && !currentBadges.contains("🏆 Serious Learner")) newBadges.add("🏆 Serious Learner");

        // 🚀 Level-Based Badges
        if (level >= 5 && !currentBadges.contains("⭐ Reached Level 5")) newBadges.add("⭐ Reached Level 5");
        if (level >= 10 && !currentBadges.contains("🌟 Reached Level 10")) newBadges.add("🌟 Reached Level 10");

        if (newBadges.isNotEmpty) {
        // ✅ Merge new badges with existing ones
        List<String> updatedBadges = List.from(currentBadges)..addAll(newBadges);

        // ✅ Store in Firestore
        await FirebaseFirestore.instance.collection('user_progress').doc(userId).update({
            "badges": updatedBadges, // Overwrite with updated list
        });

        // ✅ Show pop-up for each newly unlocked badge
        for (String badge in newBadges) {
            showBadgePopup(badge);
        }

        setState(() {
            earnedBadges = updatedBadges; // ✅ Update UI
        });

        print("🏆 New Badges Earned: $newBadges");
        }
    } catch (e) {
        print("❌ Error updating badges: $e");
    }
 }



  void showBadgePopup(String badgeName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
        return AlertDialog(
            title: Text("🏆 Achievement Unlocked!"),
            content: Text("You've earned the '$badgeName' badge!"),
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

  /// ✅ Shows a pop-up when a new feature is unlocked
  void showUnlockedFeatureDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("🎉 New Feature Unlocked!"),
          content: Text(feature),
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

  /// ✅ Fetches XP, Streak, Level, Rewards, and Unlocked Features from Firestore
  void fetchXP() async {
    try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(userId)
            .get();

        if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>?;

        
            setState(() {
                xp = data?["xp"] ?? 0;
                streak = data?["streak"] ?? 0;
                level = data?["level"] ?? 1;
                rewards = List<String>.from(data?["rewards"] ?? []);
                unlockedFeatures = List<String>.from(data?["unlocked_features"] ?? []); // ✅ Correctly update the list
                earnedBadges = List<String>.from(data?["badges"] ?? []);
            });

            // ✅ Check for newly earned badges
            checkForNewBadges();

            print("✅ XP: $xp | Streak: $streak | Level: $level | Badges: $earnedBadges");
            }

            
        } catch (e) {
            print("❌ Error fetching XP & Features: $e");
        }
}



  /// ✅ Shows a pop-up when the user earns a reward
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

            /// ✅ Welcome Message & Streak Display
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

            /// ✅ Mascot Reaction Based on XP
            Center(
              child: Column(
                children: [
                  Image.asset("assets/mascot_happy.png", width: 120), // Mascot Image
                  SizedBox(height: 10),
                  Text(
                    xp == 0 && level > 1
                        ? "🎉 You Leveled Up to Level $level!"
                        : "Great job! Keep up your streak! 🎉",
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

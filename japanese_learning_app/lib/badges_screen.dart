import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BadgesScreen extends StatefulWidget {
  @override
  _BadgesScreenState createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  String userId = "test_user"; // Replace with actual user ID when authentication is added
  List<String> earnedBadges = [];

  // ✅ Define all possible badges
  final List<Map<String, String>> allBadges = [
    {"name": "🔥 5-Day Streak", "hint": "Keep a 5-day learning streak!"},
    {"name": "🔥 10-Day Streak", "hint": "Reach a 10-day streak!"},
    {"name": "🔥 30-Day Streak", "hint": "Get a 30-day streak!"},
    {"name": "📚 First 1000 XP", "hint": "Earn 1000 XP in total!"},
    {"name": "🏆 Serious Learner", "hint": "Gain 5000 XP total!"},
    {"name": "⭐ Reached Level 5", "hint": "Reach Level 5!"},
    {"name": "🌟 Reached Level 10", "hint": "Reach Level 10!"},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserBadges();
  }

  void fetchUserBadges() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_progress')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          earnedBadges = List<String>.from(snapshot["badges"] ?? []);
        });
      }
    } catch (e) {
      print("❌ Error fetching badges: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🏆 Badges Collection")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 badges per row
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: allBadges.length,
          itemBuilder: (context, index) {
            String badgeName = allBadges[index]["name"]!;
            String badgeHint = allBadges[index]["hint"]!;

            bool isUnlocked = earnedBadges.contains(badgeName);

            return GestureDetector(
              onTap: isUnlocked
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("🔒 Locked Badge"),
                          content: Text(badgeHint),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"))
                          ],
                        ),
                      );
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: isUnlocked ? 1.0 : 0.3, // Grayscale for locked
                      child: Icon(Icons.emoji_events,
                          size: 40, color: isUnlocked ? Colors.orange : Colors.grey),
                    ),
                    SizedBox(height: 5),
                    Text(
                      badgeName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'badges_screen.dart'; // ✅ Import BadgesScreen

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")), // ✅ App Bar
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 View Badges Button - Now placed inside body correctly
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BadgesScreen()),
                );
              },
              icon: Icon(Icons.emoji_events, color: Colors.white),
              label: Text("View Badges"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
            SizedBox(height: 20), // ✅ Added space between elements

            // 🏆 Achievements Header
            Text("🏆 Achievements",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // ✅ Fetch & Display User Badges
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('user_progress')
                  .doc("test_user")
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }

                List<String> badges =
                    List<String>.from(snapshot.data!["badges"] ?? []);

                return badges.isEmpty
                    ? Text("No badges earned yet. Keep learning!",
                        style: TextStyle(color: Colors.grey))
                    : Wrap(
                        spacing: 8.0,
                        children: badges.map((badge) {
                          return Chip(
                            label: Text(badge,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            backgroundColor: Colors.blue.shade100,
                          );
                        }).toList(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ Batching XP updates instead of running multiple transactions
  Future<void> updateXP(String userId, int xpEarned) async {
    DocumentReference userRef = _db.collection('user_progress').doc(userId);

    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        int levelUpXP = 1000;

        if (!snapshot.exists) {
          transaction.set(userRef, {
            "xp": xpEarned,
            "streak": 1,
            "level": 1,
            "rewards": [],
            "lessons_completed": 1
          });
        } else {
          final data = snapshot.data() as Map<String, dynamic>?;
          int currentXP = data?["xp"] ?? 0;
          int currentLevel = data?["level"] ?? 1;
          int newXP = currentXP + xpEarned;
          int newLessonsCompleted = (data?["lessons_completed"] ?? 0) + 1;
          List<dynamic> rewards = data?["rewards"] ?? [];

          int newLevel = currentLevel;

          // Check if user levels up
          if (newXP >= levelUpXP) {
            newXP -= levelUpXP;
            newLevel += 1;
            String newReward = "🎉 Reached Level $newLevel!";
            rewards.add(newReward);
            print("🎉 Level Up! New Level: $newLevel, XP reset to $newXP, Reward: $newReward");
          }

          // ✅ Delay updates slightly to prevent transaction conflicts
          await Future.delayed(Duration(milliseconds: 100));

          transaction.update(userRef, {
            "xp": newXP,
            "level": newLevel,
            "lessons_completed": newLessonsCompleted,
            "rewards": rewards
          });
        }
      });
    } catch (e) {
      print("❌ Firestore Transaction Error: $e");
    }
  }
}

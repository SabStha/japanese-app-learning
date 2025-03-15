import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateXP(String userId, int xpEarned) async {
    DocumentReference userRef = _db.collection('user_progress').doc(userId);

    return _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      int levelUpXP = 1000;

      if (!snapshot.exists) {
        transaction.set(userRef, {
          "xp": xpEarned,
          "streak": 1,
          "level": 1,
          "rewards": [],
          "unlocked_features": ["Basic Features"], // ✅ Initialize feature list
          "lessons_completed": 1
        });
      } else {
        final data = snapshot.data() as Map<String, dynamic>?;
        int currentXP = data?["xp"] ?? 0;
        int currentLevel = data?["level"] ?? 1;
        int newXP = currentXP + xpEarned;
        int newLessonsCompleted = (data?["lessons_completed"] ?? 0) + 1;
        List<dynamic> rewards = data?["rewards"] ?? [];
        List<dynamic> unlockedFeatures = data?["unlocked_features"] ?? [];

        int newLevel = currentLevel;
        String newFeature = "";

        // Unlockable Features
        if (newLevel == 2 && !unlockedFeatures.contains("Daily Challenges")) {
          unlockedFeatures.add("Daily Challenges");
          newFeature = "🎯 Daily Challenges Unlocked!";
        } else if (newLevel == 5 && !unlockedFeatures.contains("AI Chat Mode")) {
          unlockedFeatures.add("AI Chat Mode");
          newFeature = "🤖 AI Chat Mode Unlocked!";
        } else if (newLevel == 10 && !unlockedFeatures.contains("Customizable Avatars")) {
          unlockedFeatures.add("Customizable Avatars");
          newFeature = "🧑‍🎨 Customizable Avatars Unlocked!";
        } else if (newLevel == 15 && !unlockedFeatures.contains("Leaderboard Rankings")) {
          unlockedFeatures.add("Leaderboard Rankings");
          newFeature = "🏆 Leaderboard Rankings Unlocked!";
        } else if (newLevel == 20 && !unlockedFeatures.contains("Advanced Kanji Quizzes")) {
          unlockedFeatures.add("Advanced Kanji Quizzes");
          newFeature = "📜 Advanced Kanji Quizzes Unlocked!";
        }

        // Check if user levels up
        if (newXP >= levelUpXP) {
          newXP -= levelUpXP;
          newLevel += 1;
          String newReward = "🎉 Reached Level $newLevel!";
          rewards.add(newReward);

          print("🎉 Level Up! New Level: $newLevel, XP reset to $newXP, Reward: $newReward, Feature: $newFeature");
        }

        transaction.update(userRef, {
          "xp": newXP,
          "level": newLevel,
          "lessons_completed": newLessonsCompleted,
          "rewards": rewards,
          "unlocked_features": unlockedFeatures // ✅ Update unlocked features
        });
      }
    });
  }
}

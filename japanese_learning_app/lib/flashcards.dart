import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'services/firestore_service.dart';

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();

}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final CardSwiperController controller = CardSwiperController();
  List<Map<String, String>> flashcards = [];
  String userId = "test_user"; // Replace with actual user ID
  bool _isUpdating = false; // ✅ Prevents multiple updates from firing too fast


  @override
  void initState() {
    super.initState();
    fetchFlashcards();
  }

  void fetchFlashcards() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('flashcards').get();

      print("🔥 Firestore Data Fetched: ${querySnapshot.docs.length} documents found");

      for (var doc in querySnapshot.docs) {
        print("📌 Flashcard Data: ${doc.data()}"); // Print each flashcard entry
      }

      setState(() {
        flashcards = querySnapshot.docs
            .map((doc) => {
                  "kanji": doc["kanji"] as String? ?? "",
                  "reading": doc["reading"] as String? ?? "",
                  "meaning": doc["meaning"] as String? ?? ""
                })
            .toList();
      });

      print("✅ Flashcards Loaded: ${flashcards.length} flashcards");
    } catch (e) {
      print("❌ Error fetching flashcards: $e");
    }
  }

  // ✅ Function to update XP every time a flashcard is swiped
  void _onSwipeComplete() async {
    if (!_isUpdating) {
        _isUpdating = true; // ✅ Prevents multiple updates at the same time
        String userId = "test_user"; // Replace with actual user ID
        await FirestoreService().updateXP(userId, 50); // ✅ Wait for Firestore update before allowing another
        _isUpdating = false; // ✅ Unlock for next update
    }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flashcards")),
      body: flashcards.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading while fetching data
          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: CardSwiper(
                      controller: controller,
                      cardsCount: flashcards.length,
                      onSwipe: (previousIndex, targetIndex, swipeDirection) {
                        _onSwipeComplete(); // ✅ XP will now be added on EVERY swipe
                        return true;
                      },
                      cardBuilder:
                          (context, index, percentThresholdX, percentThresholdY) {
                        return AnimatedOpacity(
                          opacity: 1.0,
                          duration: Duration(milliseconds: 500),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(flashcards[index]["kanji"]!,
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text(flashcards[index]["reading"]!,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey)),
                                  SizedBox(height: 10),
                                  Text(flashcards[index]["meaning"]!,
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

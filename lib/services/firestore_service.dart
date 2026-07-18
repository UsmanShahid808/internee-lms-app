import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference coursesRef = FirebaseFirestore.instance.collection('courses');

  // Saare courses fetch karna
  Future<List<Map<String, dynamic>>> getCourses() async {
    QuerySnapshot snapshot = await coursesRef.get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Quiz score save karna
  Future<void> saveQuizProgress(String userId, int score, int total) async {
    await FirebaseFirestore.instance
        .collection('progress')
        .doc(userId)
        .collection('quizzes')
        .add({
      'score': score,
      'total': total,
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  // User ka poora quiz progress fetch karna
  Future<List<Map<String, dynamic>>> getUserProgress(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('progress')
        .doc(userId)
        .collection('quizzes')
        .get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
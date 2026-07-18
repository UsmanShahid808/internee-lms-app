import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../services/firestore_service.dart';
import 'quiz_result_screen.dart';
import '../data/dummy_data.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int score = 0;
  int? selectedOption;
  bool answered = false;
  final FirestoreService firestoreService = FirestoreService();

  void checkAnswer(int selectedIndex, int correctIndex) {
    if (answered) return;
    setState(() {
      selectedOption = selectedIndex;
      answered = true;
      if (selectedIndex == correctIndex) score++;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (currentIndex < quizQuestions.length - 1) {
        setState(() {
          currentIndex++;
          selectedOption = null;
          answered = false;
        });
      } else {
        saveScoreAndNavigate();
      }
    });
  }

  void saveScoreAndNavigate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await firestoreService.saveQuizProgress(user.uid, score, quizQuestions.length);
      } catch (e) {
        print("Error saving progress: $e");
      }
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuizResultScreen(score, quizQuestions.length)));
  }

  Color getOptionBg(int index, int correctIndex) {
    if (!answered) return Colors.white;
    if (index == correctIndex) return AppColors.success.withOpacity(0.1);
    if (index == selectedOption && selectedOption != correctIndex) return AppColors.error.withOpacity(0.1);
    return Colors.white;
  }

  Color getOptionBorder(int index, int correctIndex) {
    if (!answered) return Color(0xFFECECF7);
    if (index == correctIndex) return AppColors.success;
    if (index == selectedOption && selectedOption != correctIndex) return AppColors.error;
    return Color(0xFFECECF7);
  }

  @override
  Widget build(BuildContext context) {
    var question = quizQuestions[currentIndex];

    return WillPopScope(
      onWillPop: () async {
        bool? exit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text("Exit Quiz?", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            content: Text("Your progress will be lost.", style: GoogleFonts.poppins(fontSize: 14)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
              TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Exit", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600))),
            ],
          ),
        );
        return exit ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Question ${currentIndex + 1}/${quizQuestions.length}", style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(gradient: AppColors.gradientPrimary, borderRadius: BorderRadius.circular(12)),
                      child: Text("Score: $score", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: (currentIndex + 1) / quizQuestions.length, backgroundColor: Color(0xFFECECF7), color: AppColors.primary, minHeight: 7)),
                SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 14, offset: Offset(0, 6))]),
                  child: Text(question["question"], style: GoogleFonts.poppins(fontSize: 17.5, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.4)),
                ),
                SizedBox(height: 22),
                ...List.generate(question["options"].length, (index) {
                  return GestureDetector(
                    onTap: () => checkAnswer(index, question["correctIndex"]),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: getOptionBg(index, question["correctIndex"]), border: Border.all(color: getOptionBorder(index, question["correctIndex"]), width: 1.6), borderRadius: BorderRadius.circular(18)),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: getOptionBorder(index, question["correctIndex"]), width: 1.6)),
                            child: Center(child: Text(String.fromCharCode(65 + index), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: getOptionBorder(index, question["correctIndex"])))),
                          ),
                          SizedBox(width: 12),
                          Expanded(child: Text(question["options"][index], style: GoogleFonts.poppins(fontSize: 13.5, color: AppColors.textDark, fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
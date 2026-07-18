import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  QuizResultScreen(this.score, this.total);

  @override
  Widget build(BuildContext context) {
    double percentage = (score / total) * 100;
    bool passed = percentage >= 50;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: passed ? AppColors.gradientPrimary : LinearGradient(colors: [Color(0xFF9CA3AF), Color(0xFF6B7280)])),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(26),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5)),
                  child: Icon(passed ? Icons.emoji_events_rounded : Icons.refresh_rounded, size: 58, color: Colors.white),
                ),
                SizedBox(height: 30),
                Text(passed ? "Great Job!" : "Keep Practicing!", style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700, color: Colors.white)),
                SizedBox(height: 10),
                Text("You scored", style: GoogleFonts.poppins(fontSize: 13.5, color: Colors.white70)),
                SizedBox(height: 8),
                Text("$score / $total", style: GoogleFonts.poppins(fontSize: 44, fontWeight: FontWeight.w800, color: Colors.white)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(22)),
                  child: Text("${percentage.toStringAsFixed(0)}%", style: GoogleFonts.poppins(fontSize: 14.5, color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 44),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                    child: ElevatedButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: AppColors.primary, shadowColor: Colors.transparent, elevation: 0),
                      child: Text("Back to Home", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../services/firestore_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService firestoreService = FirestoreService();
  bool isLoading = true;
  int quizzesCompleted = 0;
  double averageScore = 0;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  void loadProgress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        List<Map<String, dynamic>> progress = await firestoreService.getUserProgress(user.uid);
        int totalScore = 0;
        int totalPossible = 0;
        for (var quiz in progress) {
          totalScore += (quiz['score'] as num).toInt();
          totalPossible += (quiz['total'] as num).toInt();
        }
        setState(() {
          quizzesCompleted = progress.length;
          averageScore = totalPossible > 0 ? (totalScore / totalPossible) * 100 : 0;
          isLoading = false;
        });
      } catch (e) {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? "No email";
    String userName = userEmail.isNotEmpty && userEmail.contains('@') ? userEmail.split('@')[0] : "Usman";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 10, 24, 42),
                decoration: BoxDecoration(gradient: AppColors.gradientDark, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36))),
                child: Column(
                  children: [
                    Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white))]),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.35), width: 2)),
                      child: CircleAvatar(radius: 42, backgroundColor: Colors.white.withOpacity(0.15), child: Icon(Icons.person, size: 44, color: Colors.white)),
                    ),
                    SizedBox(height: 16),
                    Text("${userName[0].toUpperCase()}${userName.substring(1)}", style: GoogleFonts.poppins(fontSize: 18.5, fontWeight: FontWeight.w700, color: Colors.white)),
                    SizedBox(height: 4),
                    Text(userEmail, style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.white70)),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -26),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 22, offset: Offset(0, 10))]),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(Icons.check_circle_outline, color: AppColors.primary, size: 25),
                                  SizedBox(height: 8),
                                  Text(isLoading ? "-" : "$quizzesCompleted", style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                                  SizedBox(height: 2),
                                  Text("Quizzes", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                            Container(width: 1, height: 48, color: Color(0xFFEDEDF5)),
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(Icons.star_border_rounded, color: AppColors.warning, size: 25),
                                  SizedBox(height: 8),
                                  Text(isLoading ? "-" : "${averageScore.toStringAsFixed(0)}%", style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                                  SizedBox(height: 2),
                                  Text("Avg Score", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text("Account", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: Offset(0, 4))]),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.email_outlined, color: AppColors.primary, size: 20)),
                          title: Text("Email", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                          subtitle: Text(userEmail, style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                        ),
                      ),
                      SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                title: Text("Logout?", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                                content: Text("Are you sure you want to logout?", style: GoogleFonts.poppins(fontSize: 14)),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                    },
                                    child: Text("Logout", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                          label: Text("Logout", style: GoogleFonts.poppins(color: AppColors.error, fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16), side: BorderSide(color: AppColors.error.withOpacity(0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
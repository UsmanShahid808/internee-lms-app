import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../data/dummy_data.dart';
import '../services/quote_service.dart';
import 'course_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  Map<String, String> quote = {"quote": "", "author": ""};
  bool quoteLoading = true;
  final QuoteService quoteService = QuoteService();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() => isLoading = false);
    });
    loadQuote();
  }

  void loadQuote() async {
    Map<String, String> fetchedQuote = await quoteService.getRandomQuote();
    setState(() {
      quote = fetchedQuote;
      quoteLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    String userName = userEmail.isNotEmpty && userEmail.contains('@') ? userEmail.split('@')[0] : "Usman";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24, 10, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello, ${userName[0].toUpperCase()}${userName.substring(1)} 👋", style: GoogleFonts.poppins(fontSize: 13.5, color: AppColors.textGrey)),
                      SizedBox(height: 2),
                      Text("Continue Learning", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())),
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.gradientPrimary),
                      child: CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: AppColors.primary, size: 20)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 24, offset: Offset(0, 12))],
                ),
                child: Stack(
                  children: [
                    Positioned(right: -20, top: -20, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${dummyCourses.length} Courses Available", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w700)),
                              SizedBox(height: 6),
                              Text("Keep learning every day to grow your skills", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 12, height: 1.4)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(18)),
                          child: Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: quoteLoading
                  ? SizedBox()
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 14, offset: Offset(0, 6))],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 18),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('"${quote["quote"]}"', style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.textDark, fontStyle: FontStyle.italic, height: 1.45)),
                                SizedBox(height: 6),
                                Text("— ${quote["author"]}", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 22),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All Courses", style: GoogleFonts.poppins(fontSize: 16.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                    child: Text("${dummyCourses.length}", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        loadQuote();
                      },
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
                        itemCount: dummyCourses.length,
                        itemBuilder: (context, index) {
                          var course = dummyCourses[index];
                          List lectures = course["lectures"] ?? [];
                          int lectureCount = lectures.length;
                          Color courseColor = course["color"] != null ? Color(course["color"]) : AppColors.primary;
                          bool isOutlineStyle = index % 3 == 2;

                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailScreen(course))),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: isOutlineStyle ? Border.all(color: courseColor.withOpacity(0.3), width: 1.6) : null,
                                boxShadow: isOutlineStyle ? [] : [BoxShadow(color: courseColor.withOpacity(0.1), blurRadius: 18, offset: Offset(0, 8))],
                              ),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: course["id"] ?? UniqueKey(),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.network(
                                        course["thumbnail"] ?? "",
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return Container(width: 72, height: 72, color: courseColor.withOpacity(0.08), child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: courseColor))));
                                        },
                                        errorBuilder: (context, error, stackTrace) => Container(width: 72, height: 72, color: courseColor.withOpacity(0.1), child: Icon(Icons.image_not_supported, color: courseColor)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(color: courseColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                          child: Text(course["category"] ?? "", style: GoogleFonts.poppins(color: courseColor, fontSize: 11, fontWeight: FontWeight.w600)),
                                        ),
                                        SizedBox(height: 6),
                                        Text(course["title"] ?? "", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.textDark)),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.play_circle_outline, size: 13, color: AppColors.textGrey),
                                            SizedBox(width: 4),
                                            Text("$lectureCount lectures", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(color: courseColor.withOpacity(0.1), shape: BoxShape.circle),
                                    child: Icon(Icons.arrow_forward_ios, size: 12, color: courseColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
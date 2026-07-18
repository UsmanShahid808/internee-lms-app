import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'video_player_screen.dart';
import 'quiz_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final Map course;
  CourseDetailScreen(this.course);

  @override
  Widget build(BuildContext context) {
    List lectures = course["lectures"] ?? [];
    Color courseColor = course["color"] != null ? Color(course["color"]) : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            backgroundColor: courseColor,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.2),
                child: IconButton(icon: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: course["id"] ?? UniqueKey(),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(course["thumbnail"] ?? "", fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: courseColor)),
                    Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.5)]))),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: courseColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Text(course["category"] ?? "", style: GoogleFonts.poppins(color: courseColor, fontSize: 11.5, fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 14),
                  Text(course["title"] ?? "", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  SizedBox(height: 12),
                  Text(course["description"] ?? "", style: GoogleFonts.poppins(fontSize: 13.5, color: AppColors.textGrey, height: 1.7)),
                  SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lectures", style: GoogleFonts.poppins(fontSize: 16.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      Text("${lectures.length} videos", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                    ],
                  ),
                  SizedBox(height: 14),
                  lectures.isEmpty
                      ? Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("No lectures added yet", style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13)))
                      : Column(
                          children: List.generate(lectures.length, (index) {
                            var lecture = lectures[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(lecture["url"] ?? "", lecture["title"] ?? "Lecture"))),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 14, offset: Offset(0, 6))]),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(gradient: LinearGradient(colors: [courseColor, courseColor.withOpacity(0.7)]), borderRadius: BorderRadius.circular(14)),
                                      child: Icon(Icons.play_arrow_rounded, color: Colors.white),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(lecture["title"] ?? "Untitled", style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                          SizedBox(height: 2),
                                          Text(lecture["duration"] ?? "", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 13, color: courseColor),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [courseColor, courseColor.withOpacity(0.75)]),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: courseColor.withOpacity(0.3), blurRadius: 18, offset: Offset(0, 8))],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen())),
                        icon: Icon(Icons.quiz_outlined, size: 20),
                        label: Text("Take Quiz"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
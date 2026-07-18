import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientDark),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
                    ),
                    child: Icon(Icons.auto_stories_rounded, size: 54, color: Colors.white),
                  ),
                  SizedBox(height: 26),
                  Text("Internee LMS", style: GoogleFonts.poppins(fontSize: 27, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                  SizedBox(height: 8),
                  Text("Learn. Grow. Succeed.", style: GoogleFonts.poppins(fontSize: 13.5, color: Colors.white.withOpacity(0.85), letterSpacing: 0.5)),
                  SizedBox(height: 44),
                  SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2.2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
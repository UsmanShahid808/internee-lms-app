import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

class AppColors {
  static const primary = Color(0xFF7C7FF2);
  static const primaryDark = Color(0xFF5B5FE8);
  static const secondary = Color(0xFFF29CB4);
  static const primaryLight = Color(0xFFF1F1FE);
  static const background = Color(0xFFFAFAFD);
  static const cardBg = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF2D2B4E);
  static const textGrey = Color(0xFF8B899E);
  static const success = Color(0xFF4CC38A);
  static const error = Color(0xFFF3766C);
  static const warning = Color(0xFFF5B85C);

  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF8B8FF5), Color(0xFFA78BF7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientSoft = LinearGradient(
    colors: [Color(0xFFF1F1FE), Color(0xFFFDF1F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientDark = LinearGradient(
    colors: [Color(0xFF4B4E9E), Color(0xFF7C7FF2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internee LMS',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 17),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          hintStyle: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;
  final AuthService authService = AuthService();

  void handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields"), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      );
      return;
    }
    setState(() => isLoading = true);
    String? error = await authService.login(emailController.text.trim(), passwordController.text.trim());
    setState(() => isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(height: 250, decoration: BoxDecoration(gradient: AppColors.gradientSoft)),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 8))],
                    ),
                    child: Icon(Icons.auto_stories_rounded, size: 32, color: AppColors.primary),
                  ),
                  SizedBox(height: 22),
                  Text("Welcome back", style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  SizedBox(height: 6),
                  Text("Login to continue learning", style: GoogleFonts.poppins(fontSize: 13.5, color: AppColors.textGrey)),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 26, offset: Offset(0, 12))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email", style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                        SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(hintText: "you@example.com", prefixIcon: Icon(Icons.mail_outline_rounded, color: AppColors.textGrey, size: 20)),
                        ),
                        SizedBox(height: 16),
                        Text("Password", style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                        SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            hintText: "••••••••",
                            prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textGrey, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textGrey, size: 20),
                              onPressed: () => setState(() => obscurePassword = !obscurePassword),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.gradientPrimary,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 18, offset: Offset(0, 8))],
                            ),
                            child: ElevatedButton(
                              onPressed: isLoading ? null : handleLogin,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                              child: isLoading
                                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text("Login"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13.5),
                          children: [TextSpan(text: "Sign Up", style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w700))],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
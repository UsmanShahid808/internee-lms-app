import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;
  final AuthService authService = AuthService();

  void handleSignup() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields"), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      );
      return;
    }
    setState(() => isLoading = true);
    String? error = await authService.signUp(emailController.text.trim(), passwordController.text.trim());
    setState(() => isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created! Please login."), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(height: 210, decoration: BoxDecoration(gradient: AppColors.gradientSoft)),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textDark),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 16),
                  Text("Create account", style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  SizedBox(height: 6),
                  Text("Start your learning journey today", style: GoogleFonts.poppins(fontSize: 13.5, color: AppColors.textGrey)),
                  SizedBox(height: 26),
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
                        Text("Full Name", style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                        SizedBox(height: 8),
                        TextField(controller: nameController, decoration: InputDecoration(hintText: "Your name", prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.textGrey, size: 20))),
                        SizedBox(height: 16),
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
                            hintText: "•••••••• (min 6 characters)",
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
                              onPressed: isLoading ? null : handleSignup,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                              child: isLoading
                                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text("Create Account"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13.5),
                          children: [TextSpan(text: "Login", style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w700))],
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
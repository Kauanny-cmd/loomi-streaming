import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/inputs/custom_text_field_decoration.dart';
import 'check_forgot_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight:  constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/splash.png', height: 120),
                        const SizedBox(height: 34),
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Enter the email address you used when you joined and we\'ll send you instructions to reset your password.',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: controller,
                          decoration: CustomTextFieldDecoration.build('Email'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 44),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () async{
                              final email = controller.text.trim();

                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter your email')),
                                );
                                return;
                              }

                              try {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

                                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckForgotScreen()));

                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message ?? 'Something went wrong')),
                                );
                              }
                            }, // implementar
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFAA73F0)),
                              backgroundColor: const Color(0x33BB86FC),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text("Send reset instructions", style: TextStyle(fontSize: 16, color: Color((0xFFBB86FC)))),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Back',
                            style: TextStyle(color: Color(0xFFBB86FC), fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

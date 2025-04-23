import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loomi_streaming/modules/auth/data/google_sign.dart';
import 'package:loomi_streaming/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../components/inputs/custom_text_field_decoration.dart';
import '../components/social/social_icon.dart';
import '../core/providers/login_provider.dart';
import '../modules/auth/data/index.dart';
import 'home_screen.dart';
import 'initial_profile_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight:  constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        Image.asset('assets/images/logo.png', height: 120),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFBB86FC),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical:16 , horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 4),
                              const Text("Create an account",
                                  style: TextStyle(color: Colors.grey, fontSize: 24)),
                              const SizedBox(height: 32),
                              const Text("To get started, please complete your account registration.!",
                                  style: TextStyle(color: Colors.grey, fontSize: 14)),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SocialIcon(
                                    assetPath: 'assets/images/google_icon.png',
                                    onTap: () async {
                                      try {
                                        final credential = await signInWithGoogle();

                                        if (credential.user != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Error login with Google')),
                                        );
                                        print('Erro ao logar com Google: $e');
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 24),
                                  const SocialIcon(assetPath: 'assets/images/apple_icon.png'),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Row(children: [
                                Expanded(child: Divider(color: Colors.grey)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text("Or Sign in With", style: TextStyle(color: Colors.grey)),
                                ),
                                Expanded(child: Divider(color: Colors.grey)),
                              ]),

                              const SizedBox(height: 16),

                              // Email
                              TextFormField(
                                controller: emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: CustomTextFieldDecoration.build('Email'),
                              ),
                              const SizedBox(height: 16),

                              // Senha
                              TextFormField(
                                controller: passwordController,
                                obscureText: !loginProvider.isPasswordVisible,
                                style: const TextStyle(color: Colors.white),
                                decoration: CustomTextFieldDecoration.build("Password").copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      loginProvider.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: loginProvider.togglePasswordVisibility,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),
                              // Senha
                              TextFormField(
                                obscureText: !loginProvider.isPasswordVisible,
                                style: const TextStyle(color: Colors.white),
                                decoration: CustomTextFieldDecoration.build("Confirm your Password").copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      loginProvider.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: loginProvider.togglePasswordVisibility,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Botão Login
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () async{
                                    try {
                                      final credential = await registerUser(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        'teste',
                                      );

                                      if(credential == 'Ok'){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const InitialProfileScreen()),
                                        );
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('The password provided is too weak')),
                                        );
                                      } else if (e.code == 'email-already-in-use') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('The account already exists for that email.')),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Something went wrong')),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFAA73F0)),
                                    backgroundColor: const Color(0x33BB86FC),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text("Create Account", style: TextStyle(fontSize: 16,  color: Color((0xFFBB86FC)))),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        )
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

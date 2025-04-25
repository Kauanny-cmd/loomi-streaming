import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loomi_streaming/core/services/get_user_data.dart';
import 'package:loomi_streaming/screens/forgot_password_screen.dart';
import 'package:loomi_streaming/screens/home_screen.dart';
import 'package:loomi_streaming/screens/onboarding_screen.dart';
import 'package:loomi_streaming/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/inputs/custom_text_field_decoration.dart';
import '../components/social/social_icon.dart';
import '../core/providers/login_provider.dart';
import '../modules/auth/data/google_sign.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  child: PopScope(
                    canPop: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 2),
                          Image.asset('assets/images/splash.png', height: 120),
                          const SizedBox(height: 24),
                          const Text("Welcome Back",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          const Text("Look who is here!",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 32),

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

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen( )),
                                );
                              }, // implementar
                              child: const Text("Forgot password?",
                                  style: TextStyle(color: Color(0xFFBB86FC))),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Botão Login
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () async{
                                try {
                                  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text
                                  );
                                  final user = FirebaseAuth.instance.currentUser;

                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('uid', user!.uid);
                                  await prefs.setString('email', emailController.text);

                                  final dataUser = await getUserData();

                                  if(dataUser?['finished_onboarding'] == false){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                                    );
                                  }else{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('No user found for that email.')),
                                    );
                                  } else if (e.code == 'wrong-password') {
                                    print('Wrong password provided for that user.');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Wrong password provided for that user.'))
                                    );
                                  }
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFAA73F0)),
                                backgroundColor: const Color(0x33BB86FC),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text("Login", style: TextStyle(fontSize: 16, color: Color((0xFFBB86FC)))),
                            ),
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

                          // Google & Apple
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

                          const Spacer(),
                          // Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?",
                                  style: TextStyle(color: Colors.grey)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                  );
                                },
                                child: const Text("Sign Up!",
                                    style: TextStyle(color: Color(0xFFBB86FC))),
                              )
                            ],
                          ),
                        ],
                      ),
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

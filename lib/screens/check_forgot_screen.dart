import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loomi_streaming/screens/login_screen.dart';

class CheckForgotScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 85),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/images/splash.png', height: 30),
              const SizedBox(height: 120),
              const Expanded(
                  child: Column(
                    children: [
                      Text(
                        'The instructions were sent!',
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'If this was a valid email, instructions to reset your password will be sent to you. Please check your email.',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFAA73F0)),
                    backgroundColor: const Color(0x33BB86FC),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                  },
                  child: const Text("Login", style: TextStyle(fontSize: 16, color: Color((0xFFBB86FC)))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
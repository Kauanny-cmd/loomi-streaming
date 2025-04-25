import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loomi_streaming/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/inputs/custom_text_field_decoration.dart';
import '../core/services/index.dart';
import '../modules/methods/show_image_picker.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController nameController = TextEditingController();
  File? _imageFile;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: PopScope(
                    canPop: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/splash.png', height: 40),
                          const SizedBox(height: 24),
                          const Text("Tell us more!",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 4),
                          const Text("Complete your profile",
                              style: TextStyle(color: Colors.grey)),

                          const SizedBox(height: 32),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => showImagePickerOptions(
                                  context,
                                  onImageSelected: (file) {
                                    setState(() {
                                      _imageFile = file;
                                    });
                                  },
                                ),
                                child: Container(
                                  width: 116,
                                  height: 116,
                                  decoration: BoxDecoration(
                                    color: const Color(0x333A1C5C),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Center(
                                    child: _imageFile != null
                                        ? ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(28),
                                      child: Image.file(
                                        _imageFile!,
                                        width: 116,
                                        height: 116,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                        : const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Color(0xFFBB86FC),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHOOSE IMAGE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'A square .jpg, .gif,\nor .png image\n200x200 or larger',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),
                          // Name
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration:
                            CustomTextFieldDecoration.build('Your name'),
                          ),

                          const SizedBox(height: 26),

                          // Botão Login
                          SizedBox(
                            width: 208,
                            child: OutlinedButton(
                              onPressed: () async {
                                final response =
                                await editUser({
                                  "username": nameController.text,
                                  //"profile_picture":_imageFile!.path.toString()
                                });
                                if (response == "Ok") {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('username', nameController.text);
                                  await prefs.setString('profile_image_path', _imageFile!.path);

                                  await finishedOnboarding();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response)),
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
                              child: const Text("Continue",
                                  style: TextStyle(
                                      fontSize: 16, color: Color((0xFFBB86FC)))),
                            ),
                          ),

                          Align(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, // implementar
                              child: const Text("Back",
                                  style: TextStyle(color: Color(0xFFBB86FC))),
                            ),
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

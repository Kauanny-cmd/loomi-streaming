import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/inputs/custom_text_field_decoration.dart';
import '../core/services/index.dart';
import '../modules/methods/show_image_picker.dart';

class EditProfiledScreen extends StatefulWidget {
  final String username;
  const EditProfiledScreen({super.key, required this.username});

  @override
  State<EditProfiledScreen> createState() => _EditProfiledScreenState();
}

class _EditProfiledScreenState extends State<EditProfiledScreen> {
  final TextEditingController nameController = TextEditingController();
  File? _imageFile;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back_ios_new,
                                color: Color((0xFFBB86FC))),
                          ),
                          const SizedBox(height: 24),
                          const Text("Edit \nProfile",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
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
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: _imageFile != null
                                          ? ClipOval(
                                              child: Image.file(
                                                _imageFile!,
                                                height: 110,
                                                width: 110,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const CircleAvatar(
                                              radius: 48,
                                              backgroundColor: Colors.white24,
                                              child: Icon(Icons.person,
                                                  color: Colors.white),
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFF3A1C5C),
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(Icons.camera_alt,
                                            color: Color(0xFFBB86FC), size: 18),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 26),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHOOSE IMAGE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 14,
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
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration:
                                CustomTextFieldDecoration.build('Your name'),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () async {
                                final response = await editUser({
                                  "username": nameController.text.isEmpty ? widget.username : nameController.text,
                                });

                                if (response == "Ok") {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'username', nameController.text.isEmpty ? widget.username : nameController.text);


                                  Navigator.pop(context, true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response)),
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color((0xFFBB86FC))),
                                backgroundColor: const Color(0x33BB86FC),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text("Update profile",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFFBB86FC))),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

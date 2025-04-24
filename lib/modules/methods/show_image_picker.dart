import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/images/image_option.dart';

Future<void> showImagePickerOptions(
    BuildContext context, {
      required Function(File imageFile) onImageSelected,
    }) async {
  final picker = ImagePicker();

  Future<void> handleImageSelection(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    final imageFile = File(picked.path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(picked.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', savedImage.path);
    onImageSelected(savedImage);

  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: const Color(0xFF1F1F1F),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("CHOOSE IMAGE",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ImageOption(
                  icon: Icons.camera_alt_outlined,
                  label: "Take a photo",
                  selected: true,
                  onTap: () async {
                    Navigator.pop(context);
                    await handleImageSelection(ImageSource.camera);
                  },
                ),
                ImageOption(
                  icon: Icons.photo_outlined,
                  label: "Choose from gallery",
                  selected: false,
                  onTap: () async {
                    Navigator.pop(context);
                    await handleImageSelection(ImageSource.gallery);
                  },
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}

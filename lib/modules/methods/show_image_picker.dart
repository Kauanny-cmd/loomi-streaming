import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/images/image_option.dart';

Future<void> showImagePickerOptions(BuildContext context) async {
  final picker = ImagePicker();

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
            const Text(
              "CHOOSE IMAGE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Camera
                ImageOption(
                  icon: Icons.camera_alt_outlined,
                  label: "Take a photo",
                  selected: true,
                  onTap: () async {
                    final picked = await picker.pickImage(source: ImageSource.camera);
                    Navigator.pop(context); // Fecha o modal
                    // Trate a imagem aqui!
                  },
                ),

                // Galeria
                ImageOption(
                  icon: Icons.photo_outlined,
                  label: "Choose from gallery",
                  selected: false,
                  onTap: () async {
                    final picked = await picker.pickImage(source: ImageSource.gallery);
                    Navigator.pop(context);
                    // Trate a imagem aqui!
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

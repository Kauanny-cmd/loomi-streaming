import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;

  const SocialIcon({super.key, required this.assetPath, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF1F1F1F),
          child: Image.asset(
            assetPath,
            height: 70,
          ),
        )
    );
  }
}

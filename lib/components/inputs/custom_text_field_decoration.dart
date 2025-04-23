import 'package:flutter/material.dart';

class CustomTextFieldDecoration {
  static InputDecoration build(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF1F1F1F),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFBB86FC)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

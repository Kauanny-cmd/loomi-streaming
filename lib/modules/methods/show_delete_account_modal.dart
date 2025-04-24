import 'package:flutter/material.dart';
import 'package:loomi_streaming/core/services/delete_account.dart';
import 'package:loomi_streaming/screens/home_screen.dart';
import 'package:loomi_streaming/screens/splash_screen.dart';

void showDeleteAccountModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1E1E1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFFBB86FC)),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Warning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Are you sure you want to delete your account? \n\n'
                    'This action is irreversible and all of your data will be permanently deleted. If you\'re having any issues with our app, we\'d love to help you resolve them.',
                style: TextStyle(color: Colors.white70, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Delete
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final response = await deleteAccount();

                        if (response == 'Ok') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Account deleted!')),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => SplashScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response)),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => HomeScreen()),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color:Color((0xFFBB86FC))),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Color(0xFFBB86FC),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

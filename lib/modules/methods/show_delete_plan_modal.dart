import 'package:flutter/material.dart';
import 'package:loomi_streaming/core/services/delete_account.dart';
import 'package:loomi_streaming/screens/home_screen.dart';
import 'package:loomi_streaming/screens/splash_screen.dart';

import '../../core/services/index.dart';

void showDeletePlanModal(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFBB86FC)),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Subscription',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Image.asset('assets/images/logo.png', height: 120),
              const SizedBox(height: 24),

              // Lista de recursos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                  _buildFeatureItem('Lorem ipsum dolor sit amet.'),
                  _buildFeatureItem('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                  _buildFeatureItem('4K - Lorem ipsum dolor sit amet.'),
                  _buildFeatureItem('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                  _buildFeatureItem('Lorem ipsum dolor sit amet.'),
                  _buildFeatureItem('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                ],
              ),

              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade800),
                    bottom: BorderSide(color: Colors.grey.shade800),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plan renewal',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'Dec 12, 2023',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final response = await editUser({
                          "plan_status": false,
                        });

                        if (response == "Ok") {
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response)),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFBB86FC)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Terminate Plan',
                        style: TextStyle(
                          color: Color(0xFFBB86FC),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildFeatureItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        const Icon(Icons.check, color: Color(0xFFBB86FC), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
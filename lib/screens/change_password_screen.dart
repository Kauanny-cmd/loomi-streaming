import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isObscureCurrent = true;
  bool isObscureNew = true;
  bool isObscureConfirm = true;
  bool isLoading = false;

  void showSnackbar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> updatePassword() async {
    final user = FirebaseAuth.instance.currentUser;

    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (newPass != confirm) {
      showSnackbar('Passwords don\'t match', error: true);
      return;
    }

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      showSnackbar('Fill in all fields', error: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: current,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPass);

      showSnackbar('Password updated successfully!');
      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        showSnackbar('Incorrect current password', error: true);
      } else {
        showSnackbar(e.message ?? 'Authentication failed', error: true);
      }
    } catch (e) {
      showSnackbar('Something went wrong', error: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF141417),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFBB86FC)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change\nPassword',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                buildPasswordField(
                  label: 'Current password',
                  controller: currentPasswordController,
                  isObscure: isObscureCurrent,
                  toggle: () => setState(() => isObscureCurrent = !isObscureCurrent),
                ),
                const SizedBox(height: 24),
                buildPasswordField(
                  label: 'New password',
                  controller: newPasswordController,
                  isObscure: isObscureNew,
                  toggle: () => setState(() => isObscureNew = !isObscureNew),
                ),
                const SizedBox(height: 16),
                buildPasswordField(
                  label: 'Confirm new password',
                  controller: confirmPasswordController,
                  isObscure: isObscureConfirm,
                  toggle: () => setState(() => isObscureConfirm = !isObscureConfirm),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : updatePassword,
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFBB86FC)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Color(0xFFBB86FC))
                        : const Text(
                      'Update Password',
                      style: TextStyle(color: Color(0xFFBB86FC)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1F1F2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}

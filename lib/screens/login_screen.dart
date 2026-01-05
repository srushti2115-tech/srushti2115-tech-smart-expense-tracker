import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'phone_auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // =========================
  // 🔐 EMAIL LOGIN
  // =========================
  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please enter email and password");
      return;
    }

    try {
      setState(() => _isLoading = true);
      await _authService.login(email, password);
    } catch (e) {
      _showMessage("Invalid email or password");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // =========================
  // 🔁 FORGOT PASSWORD
  // =========================
  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showMessage("Enter your email to reset password");
      return;
    }

    try {
      await _authService.resetPassword(email);
      _showMessage("Password reset email sent");
    } catch (e) {
      _showMessage("Failed to send reset email");
    }
  }

  // =========================
  // 🔵 GOOGLE SIGN-IN
  // =========================
  Future<void> googleLogin() async {
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _showMessage("Google sign-in failed");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 📧 Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 16),

            // 🔒 Password with 👁
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 🔁 Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: resetPassword,
                child: const Text("Forgot Password?"),
              ),
            ),

            const SizedBox(height: 16),

            // 🔵 LOGIN BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : loginUser,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ),

            const SizedBox(height: 16),

            // 🔵 GOOGLE LOGIN
            OutlinedButton.icon(
              icon: const Icon(Icons.g_mobiledata, size: 30),
              label: const Text("Sign in with Google"),
              onPressed: googleLogin,
            ),

            const SizedBox(height: 12),

            // 📱 PHONE LOGIN
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PhoneAuthScreen(),
                  ),
                );
              },
              child: const Text("Login with phone number"),
            ),

            const SizedBox(height: 12),

            // ➕ CREATE ACCOUNT
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(),
                  ),
                );
              },
              child: const Text("Create new account"),
            ),
          ],
        ),
      ),
    );
  }
}

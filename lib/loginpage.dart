
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _hidePassword = true;

  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (!supabaseReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
          'Please add your Supabase URL and Publishable Key')),
      );
      return;
    }

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logging in...')),
      );
      // AuthGate automatically shows HomePage.
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  InputDecoration _decoration(String label, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFC1D9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE879A5), width: 1.5),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFFFC1D9)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE879A5),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sign in to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _decoration(
                          'Email', Icons.email_outlined),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter your email';
                          if (!_emailRegex.hasMatch(v)) return 'Please enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _password,
                        obscureText: _hidePassword,
                        decoration: _decoration(
                          'Password',
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_hidePassword
                                ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(
                              () => _hidePassword = !_hidePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter your password';
                          if (!_passwordRegex.hasMatch(v)) return 'Must be 8+ chars (1 letter & 1 number)';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      FilledButton(
                        onPressed: _handleLogin,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE879A5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Login',
                          style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context, '/register'),
                        child: const Text(
                          "Don't have an account? Register",
                          style: TextStyle(color: Color(0xFFE879A5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

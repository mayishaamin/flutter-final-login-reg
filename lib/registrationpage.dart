
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirm = true;

  final _nameRegex = RegExp(r'^[a-zA-Z\s]{2,50}$');
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!supabaseReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add Supabase URL and Key')),
      );
      return;
    }

    try {
      await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _password.text,
        data: {'full_name': _name.text.trim()},
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful!')),
      );
      Navigator.pop(context);
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
        borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
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
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Fill in your details',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _name,
                        decoration: _decoration(
                          'Full Name', Icons.person_outline),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter your name';
                          if (!_nameRegex.hasMatch(v)) return 'Enter valid name (min 2 chars)';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _decoration(
                          'Email', Icons.email_outlined),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter an email';
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
                          if (v == null || v.isEmpty) return 'Please enter a password';
                          if (!_passwordRegex.hasMatch(v)) return 'Must be 8+ chars (1 letter & 1 number)';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _confirm,
                        obscureText: _hideConfirm,
                        decoration: _decoration(
                          'Confirm Password',
                          Icons.lock_reset,
                          suffix: IconButton(
                            icon: Icon(_hideConfirm
                                ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(
                              () => _hideConfirm = !_hideConfirm),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please confirm your password';
                          if (v != _password.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      FilledButton(
                        onPressed: _handleRegister,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE879A5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Register',
                          style: TextStyle(fontSize: 16)),
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

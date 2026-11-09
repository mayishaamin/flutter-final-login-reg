import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const green = Color(0xFF789B59);
  static const strawberry = Color(0xFFF29AA5);
  static const cream = Color(0xFFFFF1E6);

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false, _hidePass = true, _hideConfirm = true;

  final _nameRegex = RegExp(r'^[a-zA-Z .]{2,50}$');
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _passwordRegex = RegExp(
    r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).{8,}$',
  );

  String? _nameCheck(String? v) =>
      v == null || v.isEmpty ? 'Enter your name' :
      !_nameRegex.hasMatch(v) ? 'Enter a valid name' : null;

  String? _emailCheck(String? v) =>
      v == null || v.isEmpty ? 'Enter your email' :
      !_emailRegex.hasMatch(v) ? 'Enter a valid email' : null;

  String? _passwordCheck(String? v) =>
      v == null || v.isEmpty ? 'Enter password' :
      !_passwordRegex.hasMatch(v)
          ? 'Use 8+ chars, uppercase, lowercase, number & symbol'
          : null;

  String? _confirmCheck(String? v) =>
      v == null || v.isEmpty ? 'Confirm password' :
      v != _password.text ? 'Passwords do not match' : null;

  Widget _field(TextEditingController c, String label, IconData icon,
      {TextInputType type = TextInputType.text,
      bool obscure = false,
      Widget? suffix,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: c,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: green),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: strawberry),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: green, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!supabaseReady) {
      _message('Supabase is not ready');
      return;
    }

    setState(() => _loading = true);

    try {
      final name = _name.text.trim();
      final email = _email.text.trim();

      final result = await Supabase.instance.client.auth.signUp(
        email: email,
        password: _password.text,
        data: {'full_name': name},
      );

      if (result.user != null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': result.user!.id,
          'name': name,
          'email': email,
        });
      }

      if (!mounted) return;

      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();

      _message('Registration Successful!');
      Navigator.pop(context);

    } on AuthException catch (e) {
      if (mounted) _message(e.message);
    } catch (e) {
      if (mounted) _message(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
      backgroundColor: cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: strawberry),
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
                          color: green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Fill in your details',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      _field(_name, 'Full Name', Icons.person_outline,
                        validator: _nameCheck),
                      const SizedBox(height: 16),

                      _field(_email, 'Email', Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        validator: _emailCheck),
                      const SizedBox(height: 16),

                      _field(_password, 'Password', Icons.lock_outline,
                        obscure: _hidePass,
                        suffix: IconButton(
                          icon: Icon(
                            _hidePass ? Icons.visibility_off : Icons.visibility,
                            color: green,
                          ),
                          onPressed: () => setState(
                            () => _hidePass = !_hidePass),
                        ),
                        validator: _passwordCheck),
                      const SizedBox(height: 16),

                      _field(_confirm, 'Confirm Password', Icons.lock_reset,
                        obscure: _hideConfirm,
                        suffix: IconButton(
                          icon: Icon(
                            _hideConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: green,
                          ),
                          onPressed: () => setState(
                            () => _hideConfirm = !_hideConfirm),
                        ),
                        validator: _confirmCheck),
                      const SizedBox(height: 24),

                      FilledButton(
                        onPressed: _loading ? null : _register,
                        style: FilledButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Register'),
                      ),
                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: strawberry),
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
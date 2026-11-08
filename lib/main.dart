
import 'package:flutter/material.dart';

import 'auth/auth_gate.dart';
import 'registrationpage.dart';
import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeSupabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediCore',

      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF1F6),
      ),

      home: const AuthGate(),

      routes: {
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

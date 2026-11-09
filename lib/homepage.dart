import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const pink = Color(0xFFFFF7F8);
  static const matcha = Color(0xFF838F58);
  static const lightPink = Color(0xFFF9D1D9);

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['full_name'] ?? 'Patient';
    final email = user?.email ?? '';

    final pages = [
      'Doctors',
      'Departments',
      'Bill Converter',
      'My Records',
      'Patient Card',
      'Hospital Info',
    ];

    return Scaffold(
      backgroundColor: lightPink,

      appBar: AppBar(
        title: const Text(
          'MediCore',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w700,
            fontFamily: 'serif',
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: pink,
        foregroundColor: matcha,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              color: pink,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [Text('Welcome, $name'), Text('Email: $email')],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const CircleAvatar(
              radius: 32,
              backgroundColor: pink,
              child: Icon(Icons.favorite, color: matcha, size: 32),
            ),

            const SizedBox(height: 5),

            const Text(
              'Smart Hospital Management System',
              style: TextStyle(color: matcha),
            ),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.2,
              ),
              itemCount: pages.length,
              itemBuilder: (context, index) => OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: matcha,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: matcha),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(pages[index], textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: matcha,
        foregroundColor: Colors.white,
        tooltip: 'Emergency',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Emergency: 999 | Health Hotline: 16262'),
            ),
          );
        },
        child: const Icon(Icons.call),
      ),
    );
  }
}


import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl =
    'https://eupfgnakzljbgnznaluq.supabase.co';

const String supabasePublishableKey =
    'sb_publishable__JGJdGYiZTQ0bT-EmOzijQ_0qMKuKba';

bool supabaseReady = false;



Future<void> initializeSupabase() async {
  if (supabaseUrl.isEmpty ||
      supabasePublishableKey.isEmpty) {
    throw Exception(
      'Supabase URL or Publishable Key is missing',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  supabaseReady = true;
}


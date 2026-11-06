import 'package:supabase_flutter/supabase_flutter.dart';


const String supabaseUrl = 'eupfgnakzljbgnznaluq.supabase.co';
const String supabasePublishableKey = 'sb_publishable__JGJdGYiZTQ0bT-EmOzijQ_0qMKuKba';

bool supabaseReady = false;

Future<void> initializeSupabase() async {
  if (supabaseUrl != 'eupfgnakzljbgnznaluq.supabase.co' &&
      supabasePublishableKey != 'sb_publishable__JGJdGYiZTQ0bT-EmOzijQ_0qMKuKba') {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
    supabaseReady = true;
  }
}

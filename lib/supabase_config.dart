import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://eqodalctdybbsjmfouzn.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxb2RhbGN0ZHliYnNqbWZvdXpuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4OTE2OTgsImV4cCI6MjA3MDQ2NzY5OH0.ltvElKlSyFSaf27rR0hRa5aei_WVahgrwoZdVvhSDIE';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

class SettingsPageScreen extends StatefulWidget {
 const SettingsPageScreen({super.key});

 @override
 State<SettingsPageScreen> createState() => _SettingsPageScreenState();
}

class _SettingsPageScreenState extends State<SettingsPageScreen> {
 
 void _logout() async {
   await Supabase.instance.client.auth.signOut();
   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: const Color(0xFF1a1a1a),
     body: Center(
       child: SafeArea(
         child: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.all(16),
             child: Column(
               children: [
                 Text(
                   'Settings Page',
                   style: const TextStyle(color: Colors.white, fontSize: 24),
                 ),
                 SizedBox(height: 20),
                 
                 ElevatedButton(
                   onPressed: _logout,
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                   ),
                   child: Text(
                     'Logout',
                     style: TextStyle(color: Colors.white, fontSize: 16),
                   ),
                 ),
               ],
             ),
           ),
         ),
       ),
     ),
   );
 }
}
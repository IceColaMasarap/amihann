import 'package:flutter/material.dart';
import 'authentication/login.dart';
import 'authentication/locsetup.dart';
import 'authentication/signup.dart';

import 'mainscreens/homepage.dart';
import 'mainscreens/mainscreen.dart';
import 'mainscreens/maps.dart';

import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(const AmihannApp());
}

class AmihannApp extends StatelessWidget {
  const AmihannApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amihann',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'roboto'),
      debugShowCheckedModeBanner: false,

      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/setup': (context) => const ChooseLocationScreen(),
        '/home': (context) => HomePageScreen(),
        '/main': (context) => const MainScreen(),
                '/maps': (context) => const MapsPageScreen(),

      },

      initialRoute: '/',
    );
  }
}

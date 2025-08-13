import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'homepage.dart';
import 'settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomePageScreen(), SettingsPageScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSOSPressed() {
    Fluttertoast.showToast(
      msg: "🚨 SOS Clicked!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
     bottomNavigationBar: BottomAppBar(
  color: const Color(0xFF2c2c2c), 
  child: Column(
    children: [
      SizedBox(
        height: 56, // <-- change height here
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home,
                        size: 26,
                        color: _selectedIndex == 0
                            ? const Color(0xFFff4757)
                            : Colors.white60),
                    const SizedBox(height: 4),
                    Text(
                      "Home",
                      style: TextStyle(
                        color: _selectedIndex == 0
                            ? const Color(0xFFff4757)
                            : Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            // SOS
            GestureDetector(
              onTap: _onSOSPressed,
              child: Container(
                width: 60, // match new size
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFff4757),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "SOS",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
      
            // Settings
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings,
                        size: 26,
                        color: _selectedIndex == 1
                            ? const Color(0xFFff4757)
                            : Colors.white60),
                    const SizedBox(height: 4),
                    Text(
                      "Settings",
                      style: TextStyle(
                        color: _selectedIndex == 1
                            ? const Color(0xFFff4757)
                            : Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

    );
  }
}

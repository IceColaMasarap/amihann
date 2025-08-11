import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/weatherapi.dart';
class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with TickerProviderStateMixin {
  late AnimationController _wobbleController;
  late Animation<double> _wobbleAnimation;
  int _selectedIndex = 1; // Emergency is selected by default
  String? _barangay;
double? _windSpeed;
double? _rainfall; // mm
String? _weatherDesc;

  @override
  void initState() {
    super.initState();
    _wobbleController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _wobbleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _wobbleController, curve: Curves.easeInOut),
    );

    _wobbleController.repeat(reverse: true);
    _fetchBarangay(); // Fetch barangay on load
    
  }

  Future<void> _fetchBarangay() async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user != null) {
    final response =
        await supabase.from('profiles').select('barangay').eq('id', user.id).maybeSingle();

    if (response != null && mounted) {
      setState(() {
        _barangay = response['barangay'] ?? 'Unknown';
      });

      // Fetch weather after we know the barangay
      final weatherData = await fetchWeather(_barangay!);
      if (weatherData != null && mounted) {
        setState(() {
          _windSpeed = weatherData['wind']['speed'] * 3.6; // m/s → km/h
          _weatherDesc = weatherData['weather'][0]['description'];
          // Example rainfall value if available
          _rainfall = weatherData['rain']?['1h'] ?? 0.0;
        });
      }
    }
  }
}


  @override
  void dispose() {
    _wobbleController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and Title
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 24.0, 30.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${_barangay ?? "Loading..."}, Dasmariñas',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),
                      Text(
                        'Amihann',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Last updated: 2 minutes ago',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShortcut(context, Icons.map, "Maps", "/maps"),
                      _buildShortcut(
                        context,
                        Icons.warning,
                        "Alerts",
                        "/alerts",
                      ),
                      _buildShortcut(
                        context,
                        Icons.menu_book,
                        "Guide",
                        "/guide",
                      ),
                      _buildShortcut(
                        context,
                        Icons.cloud,
                        "Weather",
                        "/weather",
                      ),
                      _buildShortcut(
                        context,
                        Icons.settings,
                        "Settings",
                        "/settings",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Divider(
                  color: const Color.fromARGB(28, 255, 255, 255), // Line color
                  thickness: 1, // Line thickness
                  height: 20, // Space around the divider
                  indent: 30, // Left padding
                  endIndent: 30, // Right padding
                ),
                SizedBox(height: 12),

                // Critical Alert with wobble animation
                AnimatedBuilder(
                  animation: _wobbleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _wobbleAnimation.value,
                      child: Stack(
                        clipBehavior: Clip.none, // Allow the glow to overflow
                        children: [
                          // Glow layer
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.35),
                                    blurRadius: 75, // soft glow
                                    spreadRadius: 1, // makes it extend outward
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Actual alert card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFff4757),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'CRITICAL ALERT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Typhoon Pepito Approaching',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Category 4 typhoon expected to make\nlandfall in 6 hours. Seek immediate shelter.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 16.0),
                  child: Column(
                    children: [
                      // Typhoon Status
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF2c2c2c),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFff6b6b),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Typhoon Status',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFff4757),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'HIGH RISK',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
  _windSpeed != null ? _windSpeed!.toStringAsFixed(0) : '...',
  style: TextStyle(
    color: Color(0xFF4ecdc4),
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
),

                                    Text(
                                      'Wind Speed (km/h)',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '6',
                                      style: TextStyle(
                                        color: Color(0xFF4ecdc4),
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Hours to Landfall',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Flood Warning
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF2c2c2c),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF4ecdc4),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Flood Warning',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFff4757),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'HIGH RISK',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Water Level: 4.2m / 5.5m',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '75%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: 0.75,
                              backgroundColor: Color(0xFF444444),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF4ecdc4),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Rainfall
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF2c2c2c),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4ecdc4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Rainfall',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFffa726),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'MODERATE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildShortcut(
  BuildContext context,
  IconData icon,
  String label,
  String route,
) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, route);
    },
    borderRadius: BorderRadius.circular(12),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF2c2c2c),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    ),
  );
}


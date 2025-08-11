import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedBarangay; // To store selected barangay

  // List of all barangays in Dasmariñas (alphabetical)
  final List<String> _barangays = [
    "Burol",
    "Burol I",
    "Burol II",
    "Burol III",
    "Datu Esmael",
    "Emmanuel Bergado I",
    "Emmanuel Bergado II",
    "Fatima I",
    "Fatima II",
    "Fatima III",
    "H-2",
    "Langkaan I",
    "Langkaan II",
    "Luzviminda I",
    "Luzviminda II",
    "Paliparan I",
    "Paliparan II",
    "Paliparan III",
    "Sabang",
    "Saint Peter I",
    "Saint Peter II",
    "Salawag",
    "Salitran I",
    "Salitran II",
    "Salitran III",
    "Salitran IV",
    "Sampaloc I",
    "Sampaloc II",
    "Sampaloc III",
    "Sampaloc IV",
    "Sampaloc V",
    "San Agustin I",
    "San Agustin II",
    "San Agustin III",
    "San Andres I",
    "San Andres II",
    "San Antonio de Padua I",
    "San Antonio de Padua II",
    "San Dionisio",
    "San Esteban",
    "San Francisco I",
    "San Francisco II",
    "San Isidro Labrador I",
    "San Isidro Labrador II",
    "San Jose",
    "San Juan",
    "San Lorenzo Ruiz I",
    "San Lorenzo Ruiz II",
    "San Luis I",
    "San Luis II",
    "San Manuel I",
    "San Manuel II",
    "San Mateo",
    "San Miguel",
    "San Miguel II",
    "San Nicolas I",
    "San Nicolas II",
    "San Roque",
    "San Simon",
    "Santa Cristina I",
    "Santa Cristina II",
    "Santa Cruz I",
    "Santa Cruz II",
    "Santa Fe",
    "Santa Lucia",
    "Santa Maria",
    "Santo Cristo",
    "Santo Niño I",
    "Santo Niño II",
    "Victoria Reyes",
    "Zone I",
    "Zone I-A",
    "Zone II",
    "Zone III",
    "Zone IV",
  ];

  List<String> _filteredBarangays = [];

  @override
  void initState() {
    super.initState();
    _filteredBarangays = List.from(_barangays)..sort();
    _searchController.addListener(_filterBarangays);
  }

  void _filterBarangays() {
    String query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBarangays = List.from(_barangays)..sort();
      } else {
        _filteredBarangays =
            _barangays.where((b) => b.toLowerCase().startsWith(query)).toList()
              ..sort();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Added AppBar with arrow button
      appBar: AppBar(
        backgroundColor: const Color(0XFF0f1419),
        elevation: 0,
        title: const Text(
          "Choose Your Barangay in Dasmariñas",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            color: _selectedBarangay != null ? Colors.white : Colors.grey,
            onPressed:
                _selectedBarangay != null
                    ? () async {
                      final supabase = Supabase.instance.client;
                      final user = supabase.auth.currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You must be logged in'),
                          ),
                        );
                        return;
                      }

                      try {
                        await SupabaseConfig.client
      .from('profiles')
      .upsert({
        'id': user.id,
        'barangay': _selectedBarangay,
        'locsetup': true,
      });


                        Navigator.pushNamed(context, '/home');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving barangay: $e')),
                        );
                      }
                    }
                    : null,
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0XFF0f1419), Color(0XFF19212f)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search barangay...',
                    hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                    filled: true,
                    fillColor: const Color(0xFF374151),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF4B5563),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF60A5FA),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredBarangays.length,
                    itemBuilder: (context, index) {
                      final barangay = _filteredBarangays[index];
                      return Card(
                        color: const Color(0xFF1F2937),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            barangay,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing:
                              _selectedBarangay == barangay
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                          onTap: () {
                            setState(() {
                              _selectedBarangay = barangay;
                            });
                          },
                        ),
                      );
                    },
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

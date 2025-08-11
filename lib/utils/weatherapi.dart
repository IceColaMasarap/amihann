import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> fetchWeather(String barangay) async {
  const apiKey = '6a190c3263523b4572a682d24aba7d7c';
  final url = Uri.parse(
    'https://api.openweathermap.org/data/2.5/weather?q=$barangay,PH&units=metric&appid=$apiKey',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print("Error fetching weather: ${response.statusCode}");
    return null;
  }
}

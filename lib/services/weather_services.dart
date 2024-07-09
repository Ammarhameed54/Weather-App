import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather_model.dart';

class WeatherServices {
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String ApiKey;

  WeatherServices(this.ApiKey);

  Future<Weather> getWeather(String cityName) async {
    // final response = await http
    //     .get(Uri.parse('$baseUrl?q=$cityName&appid=$ApiKey&units=metric'));
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$ApiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Load Weather Data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission Permission = await Geolocator.checkPermission();
    if (Permission == LocationPermission.denied) {
      Permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemark[0].locality;

    return city ?? '';
  }
}

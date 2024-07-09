import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherServices = WeatherServices('YOUR_API_KEY_FROM_OPENWEATHER>ORG');
  Weather? _weather;

  //

  _fetchWeather() async {
    String cityName = await _weatherServices.getCurrentCity();
    try {
      final Weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = Weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // fetch City
            Text(
              _weather?.cityName ?? 'Loading Weather',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // animation

            LottieBuilder.asset(getWeatherAnimation(_weather?.mainCondition)),
            // fetch Temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // weather Condition

            Text(
              _weather?.mainCondition ?? '',
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}

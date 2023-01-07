import 'package:equatable/equatable.dart';

class OpenWeather extends Equatable {
  final List<dynamic> weather;
  final String cityName;
  final Map<String, dynamic> main;

  const OpenWeather(
      {required this.weather, required this.cityName, required this.main});

  @override
  List<Object?> get props => [weather, cityName, main];
}

// model for the list weather
class WeatherData extends Equatable {
  final int id;
  final String description;

  const WeatherData({required this.id, required this.description});

  @override
  List<Object?> get props => [id, description];
}

// model for main weather data

class MainWeatherData extends Equatable {
  final num temp;

  const MainWeatherData({required this.temp});

  @override
  List<Object?> get props => [temp];
}

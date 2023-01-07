import 'package:weather_app_clean_architecture/features/open_weather/domain/entities/open_weather.dart';

class OpenWeatherModel extends OpenWeather {
  const OpenWeatherModel(
      {required List<dynamic> weather, required String cityName, required main})
      : super(weather: weather, cityName: cityName, main: main);

  factory OpenWeatherModel.fromJson(Map<String, dynamic> json) {
    return OpenWeatherModel(
        weather: json['weather'], cityName: json['name'], main: json['main']);
  }

  Map<String, dynamic> toJson() => {
        'weather': weather,
        'name': cityName,
        'main': main,
      };
}

// model for the list weather to get the condition/id and weather description
class WeatherDataModel extends WeatherData {
  const WeatherDataModel({required super.id, required super.description})
      : super();

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(id: json['id'], description: json['description']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'description': description};
}

// model to get the temperature from the 'main'
class MainWeatherDataModel extends MainWeatherData {
  const MainWeatherDataModel({required super.temp});

  factory MainWeatherDataModel.fromJson(Map<String, dynamic> json) {
    return MainWeatherDataModel(
      temp: json['temp'],
    );
  }

  Map<String, dynamic> toJson() => {
        'temp': temp,
      };
}

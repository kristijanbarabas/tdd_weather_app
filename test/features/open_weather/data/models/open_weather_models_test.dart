import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/models/open_weather_models.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/entities/open_weather.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  //  model needs to be a subclass of the entity
  final tOpenWeatherModel = OpenWeatherModel(
    weather: [
      {"id": 800, "main": "Clear", "description": "clear sky", "icon": "01n"}
    ],
    cityName: 'Zagreb',
    main: {"temp": 30.00},
  );
  final tWeatherDataModel = WeatherDataModel(id: 800, description: 'clear sky');
  final tMainWeatherDataModel = MainWeatherDataModel(temp: 30.0);
  test('should be a subclass of the entity open weather', () {
    //asserts
    expect(tOpenWeatherModel, isA<OpenWeather>());
  });

  test('should be a subclass of the entity weather data', () {
    //asserts
    expect(tWeatherDataModel, isA<WeatherData>());
  });

  test('should be a subclass of the entity main weather  data', () {
    //asserts
    expect(tMainWeatherDataModel, isA<MainWeatherData>());
  });

  group('fromJson', () {
    test('should return a valid open weather model when the data is a list',
        () {
      //arrange - DECODE THE JSON DATA USING jsonDecode from dart:convert
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('open_weather.json'));
      //act
      final result = OpenWeatherModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tOpenWeatherModel));
    });

    test(
        'should return a valid weather data model when the data is parsed from the open weather model',
        () {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('weather_data.json'));
      //act
      final result = WeatherDataModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tWeatherDataModel));
    });

    test(
        'should return a valid main weather data model when the data is parsed from the open weather model',
        () {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('main_weather_data.json'));
      //act
      final result = MainWeatherDataModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tMainWeatherDataModel));
    });
  });
}

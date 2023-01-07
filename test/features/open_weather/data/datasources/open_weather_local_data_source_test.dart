import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_local_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/models/open_weather_models.dart';
import 'package:weather_app_clean_architecture/mocks/mock_all.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  OpenWeatherLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = OpenWeatherLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group('getLastOpenWeather', () {
    final tOpenWeatherModel =
        OpenWeatherModel.fromJson(jsonDecode(fixture('open_weather.json')));
    test('should return open weather model when there is one in the cache',
        () async {
//arrange
      when(mockSharedPreferences!.getString(any))
          .thenReturn(fixture('open_weather.json'));
//act
      final result = await dataSource!.getLastOpenWeather();
//assert
      verify(mockSharedPreferences!.getString('CACHED_OPEN_WEATHER'));
      expect(result, equals(tOpenWeatherModel));
    });

    test('should throw a CacheException when there is no cached value',
        () async {
//arrange
      when(mockSharedPreferences!.getString(any)).thenReturn(null);
//act
      final call = dataSource!.getLastOpenWeather;
//assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });

    group('cacheOpenWeather', () {
      final tOpenWeatherModel = OpenWeatherModel(
        weather: [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01n"
          },
        ],
        cityName: 'Zagreb',
        main: {"temp": 30.00},
      );
      test('should call SharedPreferences to cache the data', () async {
//act
        dataSource!.cacheOpenWeather(tOpenWeatherModel);
//assert
        final expectedJsonString = json.encode(tOpenWeatherModel.toJson());
        verify(mockSharedPreferences!
            .setString('CACHED_OPEN_WEATHER', expectedJsonString));
      });
    });
  });
}

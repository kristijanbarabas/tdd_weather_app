import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import '../models/open_weather_models.dart';

abstract class OpenWeatherLocalDataSource {
  /// Gets the cached [OpenWeatherModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<OpenWeatherModel?>? getLastOpenWeather();
  // Cache the last data
  Future<void>? cacheOpenWeather(OpenWeatherModel? openWeatherModelToCache);
}

// this is the key that we use to save and retrieve data from shared preferences
const cachedOpenWeather = 'CACHED_OPEN_WEATHER';

class OpenWeatherLocalDataSourceImpl implements OpenWeatherLocalDataSource {
  final SharedPreferences sharedPreferences;
  const OpenWeatherLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<void>? cacheOpenWeather(OpenWeatherModel? openWeatherModelToCache) {
    return sharedPreferences.setString(
        cachedOpenWeather, json.encode(openWeatherModelToCache!.toJson()));
  }

  @override
  Future<OpenWeatherModel?>? getLastOpenWeather() async {
    final jsonString = sharedPreferences.getString(cachedOpenWeather);
    if (jsonString != null) {
      return await Future.value(
          OpenWeatherModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}

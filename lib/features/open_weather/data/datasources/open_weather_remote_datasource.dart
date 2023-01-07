import 'dart:convert';
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/models/open_weather_models.dart';
import 'package:http/http.dart' as http;

abstract class OpenWeatherRemoteDataSource {
  /// Calls the open weather API https://api.openweathermap.org/data/2.5/weather?q={cityName}&appid={a3f4c56f1d4bf4be98ac70508cd43d9e}&units=metric.
  /// with a cityName as a query and an AppId
  ///
  /// Throws a [ServerException] for all error codes.
  Future<OpenWeatherModel?>? getWeatherDataForCertainCity(String? cityName);
}

const String appId = 'a3f4c56f1d4bf4be98ac70508cd43d9e';

class OpenWeatherRemoteDataSourceImpl implements OpenWeatherRemoteDataSource {
  final http.Client client;
  const OpenWeatherRemoteDataSourceImpl({required this.client});
  // calling the API to get the remote data
  @override
  Future<OpenWeatherModel?>? getWeatherDataForCertainCity(
      String? cityName) async {
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$appId&units=metric#';
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return OpenWeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

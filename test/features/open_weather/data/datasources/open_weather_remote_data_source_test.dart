import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_remote_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/models/open_weather_models.dart';
import 'package:weather_app_clean_architecture/mocks/mock_all.mocks.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  OpenWeatherRemoteDataSourceImpl? dataSource;
  MockClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = OpenWeatherRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient!.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('remote_data_source.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient!.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getDataForTheCertainCity', () {
    final tCityName = 'Karlovac';
    final appId = 'a3f4c56f1d4bf4be98ac70508cd43d9e';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$tCityName&appid=$appId&units=metric#';
    final tOpenWeatherModel = OpenWeatherModel.fromJson(
        json.decode(fixture('remote_data_source.json')));
    test(
        'should perform a GET request on a URL with a cityName, API key and with application/json header',
        () {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      dataSource!.getWeatherDataForCertainCity(tCityName);
      //assert
      verify(
        mockHttpClient!
            .get(Uri.parse(url), headers: {'Content-Type': 'application/json'}),
      );
    });
    test('should return OpenWeather when the resposne code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource!.getWeatherDataForCertainCity(tCityName);
      //assert
      expect(result, tOpenWeatherModel);
    });

    test('should throw a ServerException when response is 404 or other error',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource!.getWeatherDataForCertainCity;
      //assert
      expect(() => call(tCityName), throwsA(TypeMatcher<ServerException>()));
    });
  });
}

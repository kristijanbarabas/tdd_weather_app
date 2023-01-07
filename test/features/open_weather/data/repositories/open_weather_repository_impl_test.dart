import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import 'package:weather_app_clean_architecture/core/error/failures.dart';
import 'package:weather_app_clean_architecture/core/network/network_info.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_local_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_remote_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/models/open_weather_models.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/repositories/open_weather_repository_impl.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/entities/open_weather.dart';

class MockRemoteDataSource extends Mock implements OpenWeatherRemoteDataSource {
}

class MockLocalDataSource extends Mock implements OpenWeatherLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  OpenWeatherRepositoryImpl? openWeatherRepositoryImpl;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    // repository must be able to accept all three parameters
    openWeatherRepositoryImpl = OpenWeatherRepositoryImpl(
        remoteDataSource: mockRemoteDataSource!,
        localDataSource: mockLocalDataSource!,
        networkInfo: mockNetworkInfo!);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getWeatherDataForCertainCity ', () {
    final String? tCity = 'Zagreb';
    // data sources returns models
    final tOpenWeatherModel = OpenWeatherModel(
      weather: [
        {"id": 800, "main": "Clear", "description": "clear sky", "icon": "01n"},
      ],
      cityName: 'Zagreb',
      main: {"temp": 30.00},
    );
    // this is the entity
    final OpenWeather tOpenWeather = tOpenWeatherModel;
    test('check if device is online', () {
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      //act
      openWeatherRepositoryImpl!.getWeatherDataForCertainCity(tCity);
      //assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestsOnline(() {
      test(
          'return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getWeatherDataForCertainCity(any))
            .thenAnswer((_) async => tOpenWeatherModel);
        //act
        final result = await openWeatherRepositoryImpl!
            .getWeatherDataForCertainCity(tCity);
        //assert
        verify(mockRemoteDataSource!.getWeatherDataForCertainCity(tCity));
        expect(result, equals(Right(tOpenWeather)));
      });

      test('return cache the data locally ', () async {
        //arrange
        when(mockRemoteDataSource!.getWeatherDataForCertainCity(any))
            .thenAnswer((_) async => tOpenWeatherModel);
        //act
        await openWeatherRepositoryImpl!.getWeatherDataForCertainCity(tCity);
        //assert
        verify(mockLocalDataSource!.cacheOpenWeather(tOpenWeatherModel));
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getWeatherDataForCertainCity(any))
            .thenThrow((ServerException()));
        //act
        final result = await openWeatherRepositoryImpl!
            .getWeatherDataForCertainCity(tCity);
        //assert
        verify(mockRemoteDataSource!.getWeatherDataForCertainCity(tCity));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastOpenWeather())
            .thenAnswer((_) async => tOpenWeatherModel);
        //act
        final result = await openWeatherRepositoryImpl!
            .getWeatherDataForCertainCity(tCity);
        //assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastOpenWeather());
        expect(result, equals(Right(tOpenWeather)));
      });

      test('should return CacheFailure when the cached data is not present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastOpenWeather())
            .thenThrow(CacheException());

        //act
        final result = await openWeatherRepositoryImpl!
            .getWeatherDataForCertainCity(tCity);
        //assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastOpenWeather());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}

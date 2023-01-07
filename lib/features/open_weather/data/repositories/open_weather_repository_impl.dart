import 'package:weather_app_clean_architecture/core/error/exceptions.dart';
import 'package:weather_app_clean_architecture/core/network/network_info.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_local_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_remote_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/entities/open_weather.dart';
import 'package:weather_app_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/repositories/open_weather_repository.dart';

class OpenWeatherRepositoryImpl implements OpenWeatherRepository {
  final OpenWeatherRemoteDataSource? remoteDataSource;
  final OpenWeatherLocalDataSource? localDataSource;
  final NetworkInfo? networkInfo;
  const OpenWeatherRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, OpenWeather?>?>? getWeatherDataForCertainCity(
      String? cityName) async {
    if (await networkInfo!.isConnected!) {
      try {
        final remoteWeather =
            await remoteDataSource!.getWeatherDataForCertainCity(cityName);
        await localDataSource!.cacheOpenWeather(remoteWeather);
        return Right(remoteWeather);
      } on ServerException {
        return Left(ServerFailure());
      }
      // if the device is offline get the local (cached) data
      // return a failure if there is no cached data
    } else {
      try {
        final localWeather = await localDataSource!.getLastOpenWeather();
        return Right(localWeather);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

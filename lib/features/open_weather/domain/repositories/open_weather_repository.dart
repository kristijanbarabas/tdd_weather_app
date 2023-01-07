import 'package:dartz/dartz.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/entities/open_weather.dart';
import '../../../../core/error/failures.dart';

// this is the contract
abstract class OpenWeatherRepository {
  // now we use the either class where the left side is always the failure and the right side is the success kind of data
  // we don't need to worry about catching excpetions anywhere else in the app than the repository that converts the exceptions into failures
  // this class will have the following interface => methods and fields exposed by classes:
  Future<Either<Failure, OpenWeather?>?>? getWeatherDataForCertainCity(
      String? city);
}

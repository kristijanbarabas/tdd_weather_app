import 'package:dartz/dartz.dart';
import 'package:weather_app_clean_architecture/core/usecases/usecase.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/entities/open_weather.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/repositories/open_weather_repository.dart';
import '../../../../core/error/failures.dart';

// here we create our business logic
// the usecase needs a repository and should have a call method
// the job of the usecase is to get the data from the repository (the entity or the failure)
class GetOpenWeatherDataForCertainCity
    implements UseCase<OpenWeather?, Params?> {
  final OpenWeatherRepository? openWeatherRepository;

  GetOpenWeatherDataForCertainCity(this.openWeatherRepository);

  // implement the method that calls the repository method to return the data for the certain city
  // we can use the callable class call
  // this interface exposes the call method
  // any interface in any app should expose the call method
  // now we have a stable interface to which every single usecase in the app must conform to
  @override
  Future<Either<Failure?, OpenWeather?>?>? call(Params? params) async {
    return await openWeatherRepository!
        .getWeatherDataForCertainCity(params!.city);
  }
}

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/open_weather.dart';
import '../../domain/usecases/get_weather_data_for_certain_city.dart';
part 'open_weather_event.dart';
part 'open_weather_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputMessage =
    'Invalid Input - The number must be a positive integer or zero ';

class OpenWeatherBloc extends Bloc<OpenWeatherEvent, OpenWeatherState> {
  final GetOpenWeatherDataForCertainCity? getOpenWeatherForCertainCity;

  OpenWeatherBloc({
    required this.getOpenWeatherForCertainCity,
  }) : super(Empty()) {
    on<OpenWeatherEvent>((event, emit) async {
      if (event is GetOpenWeatherForCertainCity) {
        emit(Loading());
        final failureOrOpenWeather =
            await getOpenWeatherForCertainCity!(Params(city: event.cityName!));
        // check if the future is null to avoid late initialization and null check used on a null value
        if (failureOrOpenWeather != null) {
          // we need to await the future
          emit(await _eitherLoadedOrErrorState(failureOrOpenWeather));
        }
      }
    });
  }

  // Return [Loaded] or [Error] state
  Future<OpenWeatherState> _eitherLoadedOrErrorState(
      Either<Failure?, OpenWeather?> failureOrOpenWeather) async {
    return await failureOrOpenWeather.fold(
        (failure) =>
            Error(errorMessage: _mapFailureToMessage(failure: failure!)),
        (openWeather) => Loaded(openWeather: openWeather!));
  }

  // Return the proper message on [Error]
  String _mapFailureToMessage({required Failure failure}) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}

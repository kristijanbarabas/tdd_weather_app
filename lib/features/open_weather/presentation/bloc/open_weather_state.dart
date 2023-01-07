part of 'open_weather_bloc.dart';

abstract class OpenWeatherState extends Equatable {
  const OpenWeatherState();

  @override
  List<Object> get props => [];
}

class Empty extends OpenWeatherState {}

class Loading extends OpenWeatherState {}

class Loaded extends OpenWeatherState {
  final OpenWeather openWeather;

  const Loaded({required this.openWeather});
}

class Error extends OpenWeatherState {
  final String errorMessage;

  const Error({required this.errorMessage});
}

part of 'open_weather_bloc.dart';

abstract class OpenWeatherEvent extends Equatable {
  const OpenWeatherEvent();

  @override
  List<Object> get props => [];
}

// This is the event that we handle in the bloc 
class GetOpenWeatherForCertainCity extends OpenWeatherEvent {
  final String? cityName;

  const GetOpenWeatherForCertainCity(this.cityName);
}

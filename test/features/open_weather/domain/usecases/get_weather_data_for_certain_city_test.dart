import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_clean_architecture/core/usecases/usecase.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/entities/open_weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/usecases/get_weather_data_for_certain_city.dart';
import 'package:weather_app_clean_architecture/mocks/mock_all.mocks.dart';

// the use case needs to get the data from the open weather repository
// how will the use case operate with the repository
// pass the repository through the constructor (loose coupling)

void main() {
  GetOpenWeatherDataForCertainCity? usecase;
  MockOpenWeatherRepository? mockOpenWeatherRepository;
  setUp(() {
    mockOpenWeatherRepository = MockOpenWeatherRepository();
    // passing in the repository into the usecase
    usecase = GetOpenWeatherDataForCertainCity(mockOpenWeatherRepository!);
  });

  final tCity = 'Zagreb';
  final tMain = {"temp": 30.00};
  final tOpenWeather =
      OpenWeather(weather: const [], cityName: tCity, main: tMain);

  test('should get weather data for the city from the repository', () async {
    //arrange
    when(mockOpenWeatherRepository!.getWeatherDataForCertainCity(any))
        .thenAnswer((_) async => Right(tOpenWeather));
    //act - we can use the call method without specifying it: usecase.call()
    final result = await usecase!(Params(city: tCity));
    //assert
    expect(result, Right(tOpenWeather));
    verify(mockOpenWeatherRepository!.getWeatherDataForCertainCity(tCity));
    verifyNoMoreInteractions(mockOpenWeatherRepository);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_clean_architecture/core/error/failures.dart';
import 'package:weather_app_clean_architecture/core/usecases/usecase.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/entities/open_weather.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/usecases/get_weather_data_for_certain_city.dart';
import 'package:weather_app_clean_architecture/features/open_weather/presentation/bloc/open_weather_bloc.dart';

class MockGetWeatherDataForCertainCity extends Mock
    implements GetOpenWeatherDataForCertainCity {}

void main() {
  OpenWeatherBloc? bloc;
  MockGetWeatherDataForCertainCity? mockGetOpenWeatherForCertainCity;

  setUp(() {
    mockGetOpenWeatherForCertainCity = MockGetWeatherDataForCertainCity();

    bloc = OpenWeatherBloc(
      getOpenWeatherForCertainCity: mockGetOpenWeatherForCertainCity,
    );
  });

  test('initialState should be Empty() ', () {
    expect(bloc!.state, equals(Empty()));
  });

  group('getDataForCertainCity', () {
    final tInput = 'Karlovac';
    final tWeather = [
      {"id": 800, "main": "Clear", "description": "clear sky", "icon": "01n"}
    ];
    final tMain = {"temp": 30.00};
    final tOpenWeather =
        OpenWeather(weather: tWeather, cityName: tInput, main: tMain);

    test('should get data from the use case', () async {
      //arrange

      when(mockGetOpenWeatherForCertainCity!(any))
          .thenAnswer((_) async => Right(tOpenWeather));
      //act
      bloc!.add(GetOpenWeatherForCertainCity(tInput));
      await untilCalled(mockGetOpenWeatherForCertainCity!(any));
      //assert
      verify(mockGetOpenWeatherForCertainCity!(Params(city: tInput)));
    });
    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      //arrange

      when(mockGetOpenWeatherForCertainCity!(any))
          .thenAnswer((_) async => Right(tOpenWeather));
      //assert - later
      final expected = [Loading(), Loaded(openWeather: tOpenWeather)];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetOpenWeatherForCertainCity(tInput));
    });

    test('should emit [Loading, Error] when getting data from the server fails',
        () async {
      //arrange

      when(mockGetOpenWeatherForCertainCity!(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      //assert - later
      final expected = [
        Loading(),
        const Error(errorMessage: serverFailureMessage)
      ];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetOpenWeatherForCertainCity(tInput));
    });
    test('should emit [Loading, Error] when getting cached data fails',
        () async {
      //arrange

      when(mockGetOpenWeatherForCertainCity!(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      //assert - later
      final expected = [
        Loading(),
        const Error(errorMessage: cacheFailureMessage)
      ];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetOpenWeatherForCertainCity(tInput));
    });
  });
}

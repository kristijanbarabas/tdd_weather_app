import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_clean_architecture/core/network/network_info.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_local_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_remote_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/repositories/open_weather_repository_impl.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/repositories/open_weather_repository.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/usecases/get_weather_data_for_certain_city.dart';
import 'package:weather_app_clean_architecture/features/open_weather/presentation/bloc/open_weather_bloc.dart';
import 'package:http/http.dart' as http;

// dependency injection
final sl = GetIt.instance;
// we can register factory - they always instantiate a NEW instance of the class
// singelton will always grant THE SAME instance, get_it will cash it
Future<void> init() async {
  //! Features - Open Weather
  sl.registerFactory(() => OpenWeatherBloc(
        // calling sl i a shorthand for sl.call(), it's a callable method, type inference
        getOpenWeatherForCertainCity: sl(),
      ));

  // Use cases - singleton is registered when the app starts, the lazy singelton is registered when it's requested as a dependency for some other class
  sl.registerLazySingleton(() => GetOpenWeatherDataForCertainCity(sl()));

  // Repository
  sl.registerLazySingleton<OpenWeatherRepository>(() =>
      OpenWeatherRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<OpenWeatherRemoteDataSource>(
      () => OpenWeatherRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<OpenWeatherLocalDataSource>(
      () => OpenWeatherLocalDataSourceImpl(sharedPreferences: sl()));
  //! Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
  //! External
  // we need to extract the await to get the instance outside of the registration of the singleton
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_clean_architecture/core/network/network_info.dart';

import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_local_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/data/datasources/open_weather_remote_datasource.dart';
import 'package:weather_app_clean_architecture/features/open_weather/domain/repositories/open_weather_repository.dart';
import 'package:weather_app_clean_architecture/features/open_weather/presentation/bloc/open_weather_bloc.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<OpenWeatherRepository>()])
@GenerateNiceMocks([MockSpec<OpenWeatherRemoteDataSource>()])
@GenerateNiceMocks([MockSpec<OpenWeatherLocalDataSource>()])
@GenerateNiceMocks([MockSpec<DataConnectionChecker>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
@GenerateNiceMocks([MockSpec<SharedPreferences>()])
@GenerateNiceMocks([MockSpec<Client>()])
@GenerateNiceMocks([MockSpec<GetOpenWeatherForCertainCity>()])
import 'mock_all.mocks.dart';

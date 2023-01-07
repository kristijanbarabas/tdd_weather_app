import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_clean_architecture/core/error/failures.dart';

// the usecase defines the return type of the [call] function
// params allow us to accsess the parameter passed into the concrete class
abstract class UseCase<Type, Params> {
  Future<Either<Failure?, Type?>?>? call(Params params);
}

// we create the params & noparams class which can be shared across all features

class Params extends Equatable {
  final String city;

  const Params({required this.city});

  @override
  List<Object?> get props => [city];
}

// if we don't have any parameters to pass into the call function we insert the NoParams class
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

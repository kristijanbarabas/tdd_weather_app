import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/presentation/constants.dart';
import '../../data/models/open_weather_models.dart';
import '../../domain/entities/open_weather.dart';

class OpenWeatherDisplay extends StatelessWidget {
  final OpenWeather openWeather;
  const OpenWeatherDisplay({super.key, required this.openWeather});

  @override
  Widget build(BuildContext context) {
    final parsedOpenWeather =
        WeatherDataModel.fromJson(openWeather.weather.single);
    final parsedTemperatureData =
        MainWeatherDataModel.fromJson(openWeather.main);
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    openWeather.cityName,
                    textAlign: TextAlign.center,
                    style: kOpenWeatherDisplayTextStyle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child:
                      displayAnimationOnWeatherCondition(parsedOpenWeather.id),
                ),
                Expanded(
                    child: Text(
                        '${parsedTemperatureData.temp.toStringAsFixed(0)}°C',
                        style: kOpenWeatherDisplayTextStyle,
                        textAlign: TextAlign.center))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    getMessage(parsedTemperatureData.temp),
                    textAlign: TextAlign.center,
                    style: kOpenWeatherDisplayTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LottieBuilder displayAnimationOnWeatherCondition(int condition) {
    if (condition < 300) {
      return Lottie.asset('assets/animations/thunderstorm.json');
    } else if (condition < 600) {
      return Lottie.asset('assets/animations/rain.json');
    } else if (condition < 700) {
      return Lottie.asset('assets/animations/snowman.json');
    } else if (condition < 800) {
      return Lottie.asset('assets/animations/fog.json');
    } else if (condition == 800) {
      return Lottie.asset('assets/animations/sunny.json');
    } else if (condition <= 804) {
      return Lottie.asset('assets/animations/clouds.json');
    } else {
      return Lottie.asset('assets/animations/now_found.json');
    }
  }

  String getMessage(num temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}

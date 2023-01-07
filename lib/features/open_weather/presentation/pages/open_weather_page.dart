import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_clean_architecture/core/presentation/constants.dart';
import 'package:weather_app_clean_architecture/features/open_weather/presentation/bloc/open_weather_bloc.dart';
import '../../../../injection_container.dart';
import 'package:weather_app_clean_architecture/features/open_weather/presentation/widgets/widgets.dart';

class OpenWeatherPage extends StatelessWidget {
  const OpenWeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return buildUI(context: context);
  }

  Scaffold buildUI({required BuildContext context}) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.darken),
                image: kAppBackgroundImage,
                fit: BoxFit.cover)),
        child: BlocProvider(
          create: (_) => sl<OpenWeatherBloc>(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              children: [
                // Top half
                const SearchWidget(),
                // Sized box for division between search widget and weather data display
                const SizedBox(
                  height: 20,
                ),
                // Bottom half
                BlocBuilder<OpenWeatherBloc, OpenWeatherState>(
                    builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return const CircularProgressIndicator();
                  } else if (state is Loaded) {
                    return OpenWeatherDisplay(openWeather: state.openWeather);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.errorMessage,
                    );
                  } else {
                    return const Text('Failed!');
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

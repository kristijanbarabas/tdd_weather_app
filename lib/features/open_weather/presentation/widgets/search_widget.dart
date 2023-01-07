import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/constants.dart';
import '../bloc/open_weather_bloc.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();
  late String inputString;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            // Input Formatter allows only Strings to avoid errors by inputing numbers and special characters
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
            ],
            controller: controller,
            style: kOpenWeatherDisplayTextStyle.copyWith(fontSize: 20),
            decoration: InputDecoration(
                enabledBorder:
                    const OutlineInputBorder(borderSide: kBorderSide),
                focusedBorder:
                    const OutlineInputBorder(borderSide: kBorderSide),
                hintText: 'Input a city name...',
                hintStyle: kOpenWeatherDisplayTextStyle.copyWith(fontSize: 20)),
            onChanged: (value) {
              inputString = value;
            },
            onSubmitted: (_) => findCityWeather(),
          ),
        ),
        Expanded(
          child: GestureDetector(
              onTap: () => findCityWeather(),
              child: const Icon(
                Icons.search,
                size: 50,
                color: Colors.white,
              )),
        )
      ],
    );
  }

  void findCityWeather() {
    BlocProvider.of<OpenWeatherBloc>(context)
        .add(GetOpenWeatherForCertainCity(inputString));
    // clear the controller
    controller.clear();
    // reset the string value
    inputString = '';
  }
}

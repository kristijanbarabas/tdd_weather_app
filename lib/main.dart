import 'package:flutter/material.dart';
import 'package:weather_app_clean_architecture/features/open_weather/presentation/pages/open_weather_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open Weather Page',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(primary: Colors.black)),
      home: const OpenWeatherPage(),
    );
  }
}

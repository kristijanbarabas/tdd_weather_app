import 'package:flutter/material.dart';

// styling variables for widgets
// depending on the time of the day styling is different
final DateTime now = DateTime.now();
// text styling
final TextStyle kOpenWeatherDisplayTextStyle = now.hour < 17
    ? TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 2
          ..color = Colors.white,
        // text outline for better visibility
        shadows: const [
            Shadow(
                // bottomLeft
                offset: Offset(-1.5, -1.5),
                color: Colors.black),
            Shadow(
                // bottomRight
                offset: Offset(1.5, -1.5),
                color: Colors.black),
            Shadow(
                // topRight
                offset: Offset(1.5, 1.5),
                color: Colors.black),
            Shadow(
                // topLeft
                offset: Offset(-1.5, 1.5),
                color: Colors.black),
          ])
    : const TextStyle(
        fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white);

final TextStyle kMessageDisplayTextStyle = now.hour < 17
    ? TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 2
          ..color = Colors.white,
        // text outline for better visibility
        shadows: const [
            Shadow(
                // bottomLeft
                offset: Offset(-1.5, -1.5),
                color: Colors.black),
            Shadow(
                // bottomRight
                offset: Offset(1.5, -1.5),
                color: Colors.black),
            Shadow(
                // topRight
                offset: Offset(1.5, 1.5),
                color: Colors.black),
            Shadow(
                // topLeft
                offset: Offset(-1.5, 1.5),
                color: Colors.black),
          ])
    : const TextStyle(
        fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white);
// background images
ImageProvider<Object> kAppBackgroundImage = now.hour < 17
    ? const AssetImage(
        'assets/images/city_day.jpg',
      )
    : const AssetImage('assets/images/city_night.jpg');

// text field border color
const BorderSide kBorderSide = BorderSide(width: 3, color: Colors.white);

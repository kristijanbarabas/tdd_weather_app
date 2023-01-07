import 'package:flutter/material.dart';
import '../../../../core/presentation/constants.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  const MessageDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Text(
        message,
        style: kMessageDisplayTextStyle,
      ),
    );
  }
}

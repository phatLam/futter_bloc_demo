import 'package:flutter/material.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('🙈', style: TextStyle(fontSize: 64),),
        Text('something went wrong')
      ],
    );
  }
}

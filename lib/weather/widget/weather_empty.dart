import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🏙️', style: TextStyle(fontSize: 64)),
        Text(
          S.of(context).pageWeather_des_empty,
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}

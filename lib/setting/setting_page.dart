import 'package:demo2/weather/cubit/weather_cubit.dart';
import 'package:demo2/weather/cubit/weather_cubit.dart';
import 'package:demo2/weather/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  const SettingPage._();

  static Route<String> route() {
    return MaterialPageRoute(
      builder: (context) => const SettingPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            BlocBuilder<WeatherCubit, WeatherState>(
              buildWhen: (previous, current) =>
                  previous.temperatureUnits != current.temperatureUnits,
              builder: (context, state) {
                return ListTile(
                  title: const Text('Temperature Units'),
                  isThreeLine: true,
                  subtitle: const Text(
                    'Use metric measurements for temperature units.',
                  ),
                  trailing: Switch(
                    value: state.temperatureUnits.isCelsius,
                    onChanged: (value) =>
                        context.read<WeatherCubit>().toggleUnits(),
                  ),
                );
              },
            ),
          ],
        ));
  }
}

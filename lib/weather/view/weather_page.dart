import 'package:demo2/search/search_page.dart';
import 'package:demo2/weather/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/weather_populated.dart';
import '../widget/widgets.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // Navigate to settings page
              final city = await Navigator.of(context).push(SearchPage.route());
              if (!context.mounted)  return;
              print("city = $city");
              await context.read<WeatherCubit>().fetchWeather(city);
            },
          ),
        ],
      ),
      body: Center(
        child:
        BlocBuilder<WeatherCubit, WeatherState>(builder: (context, state) {
          return switch (state.status) {
            WeatherStatus.initial => const WeatherEmpty(),
            WeatherStatus.loading => const WeatherLoading(),
            WeatherStatus.failure => const WeatherError(),
            WeatherStatus.success =>
                WeatherPopulated(
                  weather: state.weather,
                  units: state.temperatureUnits,
                  onRefresh: () {
                    return context.read<WeatherCubit>().refreshWeather();
                  },
                ),
          };
        }),
      ),
    );
  }
}

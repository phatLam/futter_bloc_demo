import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repo/weather_repo.dart' show WeatherRepo;

import '../models/weather.dart';

part 'weather_state.dart';

part 'weather_cubit.g.dart';

//HydratedCubit is an extension of Cubit which handles persisting and restoring state across sessions.
class WeatherCubit extends HydratedCubit<WeatherState> {
  WeatherCubit(this._weatherRepo) : super(WeatherState());

  final WeatherRepo _weatherRepo;

  @override
  WeatherState? fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) {
      return;
    }
    emit(state.copyWith(status: WeatherStatus.loading));
    try {
      final weather =
      Weather.fromRepository(await _weatherRepo.getWeather(city));
      final units = state.temperatureUnits;
      final value = units.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;
      emit(state.copyWith(
          status: WeatherStatus.success,
          weather: weather.copyWith(temperature: Temperature(value: value)),
          temperatureUnits: units));
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;
    if (state.weather == Weather.empty) return;
    try {
      final weather = Weather.fromRepository(
          await _weatherRepo.getWeather(state.weather.location));
      final units = state.temperatureUnits;
      final value = units.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;
      emit(state.copyWith(
          status: WeatherStatus.success,
          weather: weather.copyWith(temperature: Temperature(value: value)),
          temperatureUnits: units));
    } on Exception {
      emit(state);
    }
  }

  toggleUnits() {
    final unit = state.temperatureUnits.isFahrenheit
        ? TemperatureUnits.celsius
        : TemperatureUnits.fahrenheit;
    if (!state.status.isSuccess) {
      return emit(state.copyWith(temperatureUnits: unit));
    }
    final weather = state.weather;
    if (weather != Weather.empty) {
      final temperature = weather.temperature;
      final value = unit.isCelsius ? temperature.value.toCelsius()
          : temperature.value.toFahrenheit();
      emit(state.copyWith(
          temperatureUnits: unit,
          weather: weather.copyWith(temperature: Temperature(value: value))
      ));
    }
  }
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;

  double toCelsius() => (this - 32) * 5 / 9;
}

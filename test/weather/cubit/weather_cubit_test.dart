import 'package:demo2/weather/cubit/weather_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repo/weather_repo.dart' as weather_repository;
import 'package:weather_repo/weather_repo.dart';
import '../../helpers/hydrated_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

const weatherLocation = 'London';
const weatherCondition = weather_repository.WeatherCondition.rainy;
const weatherTemperature = 9.8;

class MockWeatherRepo extends Mock implements WeatherRepo {}

class MockWeather extends Mock implements weather_repository.Weather {}

void main() {
  initHydratedStorage();

  group(
    'WeatherCubit',
    () {
      late WeatherCubit weatherCubit;
      late weather_repository.WeatherRepo repo;
      late weather_repository.Weather weather;
      setUp (
        () async{
          repo = MockWeatherRepo();
          weather = MockWeather();
          when(() => weather.temperature).thenReturn(weatherTemperature);
          when(() => weather.condition).thenReturn(weatherCondition);
          when(() => weather.location).thenReturn(weatherLocation);
          when(() => repo.getWeather(any()))
              .thenAnswer((_) async => weather);
          weatherCubit = WeatherCubit(repo);
        },
      );

      test(
        'initial state is correct',
        () {
          final weatherCubit = WeatherCubit(repo);
          expect(weatherCubit.state, WeatherState());
        },
      );

      group(
        'toJson/fromJson',
        () {
          test(
            'work property',
            () {
              final weatherCubit = WeatherCubit(repo);
              expect(
                  weatherCubit
                      .fromJson(weatherCubit.toJson(weatherCubit.state)),
                  weatherCubit.state);
            },
          );
        },
      );

      group(
        'fetchWeather',
        () {
          blocTest<WeatherCubit, WeatherState>(
            'emit nothing when input empty',
            build: () => weatherCubit,
            act: (WeatherCubit cubit) {
              cubit.fetchWeather(null);
            },
            expect: () => <WeatherState>[],
          );

          blocTest<WeatherCubit, WeatherState>(
            'emits [loading, failure] when getWeather throws',
            setUp: () {
              when(() => repo.getWeather(any())).thenThrow(Exception('oops'));
            },
            build: () => weatherCubit,
            act: (cubit) {
              cubit.fetchWeather(weatherLocation);
            },
            expect: () => <WeatherState>[
              WeatherState(status: WeatherStatus.loading),
              WeatherState(status: WeatherStatus.failure)
            ],
          );
          blocTest<WeatherCubit, WeatherState>(
            'calls getWeather with correct city',
            build: () => weatherCubit,
            act: (bloc) {
              bloc.fetchWeather(weatherLocation);
            },
            verify: (bloc) {
              verify(() => repo.getWeather(weatherLocation)).called(1);
            },
          );
          blocTest<WeatherCubit, WeatherState>(
            'emits [loading, success] when getWeather returns (fahrenheit)',
            build: () => weatherCubit,
            act: (bloc) {},
            expect: () => <WeatherState>[
              // TODO: implement
            ],
          );
        },
      );
    },
  );
}

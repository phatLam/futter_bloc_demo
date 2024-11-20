import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart' as open_meteo_api;
import 'package:weather_repo/weather_repo.dart';
import 'package:test/test.dart';

class MockOpenMeteoApiClient extends Mock
    implements open_meteo_api.OpenMeteoApiClient {}

class MockLocation extends Mock implements open_meteo_api.Location {}

class MockWeather extends Mock implements open_meteo_api.Weather {}

void main() {
  group(
    'WeatherRepository',
    () {
      late open_meteo_api.OpenMeteoApiClient weatherApiClient;
      late WeatherRepo weatherRepo;
      setUp(
        () {
          weatherApiClient = MockOpenMeteoApiClient();
          weatherRepo = WeatherRepo(weatherApiClient: weatherApiClient);
        },
      );

      group(
        'getWeather',
        () {
          const city = 'chicago';
          const latitude = 41.85003;
          const longitude = -87.65005;
          test(
            'calls locationSearch with correct city',
            () async {
              try {
                await weatherRepo.getWeather(city);
              } catch (_) {} // Ignore any potential exceptions

              // Verify that locationSearch was called with the correct city
              verify(() => weatherApiClient.locationSearch(city)).called(1);
            },
          );

          test(
            'throws when location search fails',
            () async {
              final exception = Exception("oops");
              when(() => weatherApiClient.locationSearch(any()))
                  .thenThrow(exception);
              expect(
                  () async => weatherRepo.getWeather(city), throwsA(exception));
            },
          );

          test(
            'calls getWeather with correct latitude/longitude',
            () async {
              final location = MockLocation();
              when(() => location.longitude).thenReturn(longitude);
              when(() => location.latitude).thenReturn(latitude);
              when(() => weatherApiClient.locationSearch(any())).thenAnswer(
                (invocation) async => location,
              );
              try {
                await weatherRepo.getWeather(city);
              } catch (_) {}
              verify(
                () => weatherApiClient.getWeather(
                    latitude: latitude, longitude: longitude),
              ).called(1);
            },
          );
          test(
            'throws when getWeather fails',
            () {
              final exception = Exception("oops");
              final location = MockLocation();
              when(() => location.longitude).thenReturn(longitude);
              when(() => location.latitude).thenReturn(latitude);
              when(
                () => weatherApiClient.getWeather(
                    latitude: latitude, longitude: longitude),
              ).thenThrow(exception);
              when(() => weatherApiClient.locationSearch(any())).thenAnswer((invocation) async => location ,);
              expect(() => weatherRepo.getWeather(city), throwsA(exception));
            },
          );
          test(
            "returns correct weather on success (clear)",
            () {},
          );
        },
      );
    },
  );
}

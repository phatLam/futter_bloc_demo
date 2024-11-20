import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:open_meteo_api/src/open_meteo_api_client.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('OpenMeteoApiClient', () {
    late http.Client httpClient;
    late OpenMeteoApiClient apiClient;
    setUpAll(
      () {
        registerFallbackValue(FakeUri());
      },
    );
    setUp(
      () {
        httpClient = MockHttpClient();
        apiClient = OpenMeteoApiClient(httpClient: httpClient);
      },
    );
    group(
      'constructor',
      () {
        test(
          'does not require an httpClient',
          () {
            expect(OpenMeteoApiClient(), isNotNull);
          },
        );
      },
    );

    group(
      'locationSearch',
      () {
        const query = 'mock-query';
        test(
          'makes correct http request',
          () async {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(200);
            when(() => response.body).thenReturn('{}');
            when(() => httpClient.get(any())).thenAnswer((_) async => response);
            try {
              await apiClient.locationSearch(query);
            } catch (_) {}
            //Use verify to ensure the get method was called exactly once (called(1)) with the expectedUri
            verify(
              () => httpClient.get(Uri.https(
                'geocoding-api.open-meteo.com',
                '/v1/search',
                {'name': query, 'count': '1'},
              )),
            ).called(1);
          },
        );

        test(
          'throws LocationRequestFailure on non-200 response',
          () {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(400);
            when(() => httpClient.get(any())).thenAnswer(
              (invocation) async => response,
            );
            expect(() async => apiClient.locationSearch(query),
                throwsA(isA<LocationRequestFailure>()));
          },
        );

        test(
          'throws LocationNotFoundFailure on empty response ',
          () async {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(200);
            when(() => response.body)
                .thenAnswer((invocation) => '{"results": []}');
            when(() => httpClient.get(any()))
                .thenAnswer((invocation) async => response);
            await expectLater(apiClient.locationSearch(query),
                throwsA(isA<LocationNotFoundFailure>()));
          },
        );

        test(
          "returns Location on valid response",
          () async {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(200);
            when(() => response.body).thenReturn(
              '''
{
  "results": [
    {
      "id": 4887398,
      "name": "Chicago",
      "latitude": 41.85003,
      "longitude": -87.65005
    }
  ]
}''',
            );
            when(() => httpClient.get(any()))
                .thenAnswer((invocation) async => response);
            final actual = await apiClient.locationSearch(query);
            expect(
                actual, isA<Location>().having((p0) => p0.id, "id", 4887398));
          },
        );
      },
    );

    group('getWeather', () {
      const latitude = 37.7749;const longitude = -122.4194;
      const validJsonResponse = '''
      {
"latitude": 43,
"longitude": -87.875,
"generationtime_ms": 0.2510547637939453,
"utc_offset_seconds": 0,
"timezone": "GMT",
"timezone_abbreviation": "GMT",
"elevation": 189,
"current_weather": {
"temperature": 15.3,
"windspeed": 25.8,
"winddirection": 310,
"weathercode": 63,
"time": "2022-09-12T01:00"
}
}
    ''';

      test('returns Weather on successful response', () async {
        when(() => httpClient.get(any())).thenAnswer((_) async =>
            http.Response(validJsonResponse, 200));

        final weather = await apiClient.getWeather(latitude: latitude, longitude: longitude);

        expect(weather, isA<Weather>());
        expect(weather.temperature, 15.3);
      });

      test('throws WeatherRequestFailure on non-200 response', () async {
        when(() => httpClient.get(any())).thenAnswer(
                (_) async => http.Response('{}', 404));

        expect(
              () async => await apiClient.getWeather(latitude: latitude, longitude: longitude),throwsA(isA<WeatherRequestFailure>()),
        );
      });

      test('throws WeatherNotFoundFailure when current_weather is missing',
              () async {
            when(() => httpClient.get(any())).thenAnswer((_) async =>
                http.Response('{"invalid": "data"}', 200));

            expect(
                  () async => await apiClient.getWeather(latitude: latitude, longitude: longitude),
              throwsA(isA<WeatherNotFoundFailure>()),
            );
          });


    });
  });
}

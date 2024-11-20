enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  unknown,
}

class Weather {
  final String location;
  final double temperature;
  final WeatherCondition condition;

  Weather(
      {required this.location,
      required this.temperature,
      required this.condition});
}

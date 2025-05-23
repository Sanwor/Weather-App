class Weather {
  final String cityName;
  final dynamic temperature;
  final String mainCondition;
  final dynamic timeZone;
  final dynamic sunrise;
  final dynamic sunset;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.timeZone,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],
        timeZone: json['timezone'],
        sunrise: json['sys']['sunrise'].toDouble(),
        sunset: json['sys']['sunset'].toDouble());
  }
}

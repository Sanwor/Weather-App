class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int timeZone;
  final int sunRise;
  final int sunSet;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.timeZone,
    required this.sunRise,
    required this.sunSet,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],
        timeZone: json['timezone'],
        sunRise: json['sys']['sunrise'],
        sunSet: json['sys']['sunset']);
  }
}

class Weather {
  final String cityName;
  final dynamic temperature;
  final String mainCondition;
  final dynamic timeZone;
  final dynamic sunrise;
  final dynamic sunset;
  final dynamic feelsLike;
  final dynamic tempMax;
  final dynamic tempMin;
  final dynamic windSpeed;
  final dynamic windDeg;
  final dynamic humidity;
  final dynamic pressure;
  final dynamic visibility;


  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.timeZone,
    required this.sunrise,
    required this.sunset,
    required this.feelsLike,
    required this.tempMax,
    required this.tempMin,
    required this.windSpeed,
    required this.windDeg,
    required this.humidity,
    required this.pressure,
    required this.visibility,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],
        timeZone: json['timezone'],
        sunrise: json['sys']['sunrise'].toDouble(),
        sunset: json['sys']['sunset'].toDouble(),
        feelsLike: json['main']['feels_like'].toDouble(),
        tempMax: json['main']['temp_max'].toDouble(),
        tempMin: json['main']['temp_min'].toDouble(),
        windSpeed: json['wind']['speed'].toDouble(),
        windDeg: json['wind']['deg'].toDouble(),
        humidity: json['main']['humidity'].toDouble(),
        pressure: json['main']['pressure'].toString(),
        visibility: json['visibility'].toDouble());
  }
}

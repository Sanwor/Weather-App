import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/app_config/constant.dart';
import '../model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('$baseUrl?q=$cityName&appid=$weatherApiKey&units=metric'));

    if (response.statusCode == 200) {
      var data = Weather.fromJson(jsonDecode(response.body));
      log(data.toString());
      return data;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    //convert location into a list of placemark objects
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from first placemark
    String? city = placemark[0].locality;
    return city ?? "";
  }

  getWeatherWithCity(value, context) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$value&units=metric&appid=$weatherApiKey'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                color: const Color(0xff8678cd),
                height: 60,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Unauthorized " +
                          jsonDecode(response.body)["message"].toString(),
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                )),
          ),
        ));
      }
      var mySnackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              color: const Color(0xff8678cd),
              height: 60,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    jsonDecode(response.body)["message"].toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              )),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
      // throw Exception('Failed to load weather data');
    }
  }
}

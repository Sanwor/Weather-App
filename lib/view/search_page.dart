import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/app_config/utils.dart';
import 'package:weather_app/services/weather_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isDay = false;
  dynamic _weather;
  bool isLoading = false;

  //weather animation
  String getWeatherAnimation(String? mainCondition, isDay) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'snow':
        return 'assets/snow.json';
      case 'clear':
        return isDay == true ? "assets/sunny.json" : "assets/night.json";

      case 'wind':
        return 'assets/windy.json';

      case 'rain':
      case 'drizzle':
      case 'showerrain':
      case 'thunderstorm':
        return 'assets/rainy.json';

      case 'clouds':
      case 'mostlycloudy':
      case 'partlycloudy':
      case 'mist':
      case 'fog':
      case 'smoke':
      case 'haze':
      case 'dust':
        return 'assets/cloudy.json';

      default:
        return 'assets/sunny.json';
    }
  }

  //textediting controller
  TextEditingController searchController = TextEditingController();

  reload() async {}

  @override
  Widget build(BuildContext context) {
    dynamic backgroundColor = isDay == true
        ? [
            Color.fromARGB(255, 151, 194, 250), // light sky blue
            Color(0xFFF0F9FF), // very light blue/white
          ]
        : [
            Color.fromARGB(255, 2, 18, 38), // light sky blue
            Color.fromARGB(255, 32, 68, 134), // very light blue/white
          ];
    if (_weather != null) {
      backgroundColor = isDay == true
          ? [
              Color.fromARGB(255, 151, 194, 250), // light sky blue
              Color(0xFFF0F9FF), // very light blue/white
            ]
          : [
              Color.fromARGB(255, 2, 18, 38), // light sky blue
              Color.fromARGB(255, 32, 68, 134), // very light blue/white
            ];
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDay == true
              ? Color.fromARGB(255, 151, 194, 250)
              : Color.fromARGB(255, 2, 18, 38),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            color: isDay == false
                ? Color.fromARGB(255, 151, 194, 250)
                : Color.fromARGB(255, 4, 18, 54),
          ),
        ),
        body: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: backgroundColor),
          ),
          child: RefreshIndicator(
            color: Colors.black,
            onRefresh: () {
              setState(() {
                isLoading = true;
              });
              return Future.delayed(const Duration(seconds: 1), () async {
                var data = await WeatherServices()
                    // ignore: use_build_context_synchronously
                    .getWeatherWithCity(searchController.text, context);

                setState(() {
                  _weather = data;
                  isLoading = false;
                });
              });
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Column(children: [
                  // Search Textfield
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    style: GoogleFonts.pressStart2p(
                        textStyle: TextStyle(
                            fontSize: 10,
                            color: isDay == false
                                ? Color.fromARGB(255, 151, 194, 250)
                                : Colors.black)),
                    cursorColor: isDay == false
                        ? Color.fromARGB(255, 151, 194, 250)
                        : Colors.black,
                    onSubmitted: (value) => handleSearch(value),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  isLoading == true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: isDay == false
                                        ? Color.fromARGB(255, 151, 194, 250)
                                        : Colors.black,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Loading...',
                                    style: GoogleFonts.pressStart2p(
                                        textStyle: TextStyle(
                                            fontSize: 12,
                                            color: isDay == false
                                                ? Color.fromARGB(
                                                    255, 151, 194, 250)
                                                : Colors.black)),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            _weather == null
                                ? SizedBox(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Please enter the city name.',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.pressStart2p(
                                              textStyle: TextStyle(
                                            color: isDay == false
                                                ? Color.fromARGB(
                                                    255, 151, 194, 250)
                                                : Colors.black,
                                            fontSize: 12,
                                          )),
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 50,
                                  ),
                            // Weather UI
                            _weather == null
                                ? SizedBox()
                                : Column(
                                    children: [
                                      //city name
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color:
                                                Color.fromARGB(255, 236, 24, 9),
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text((_weather.cityName),
                                              style: GoogleFonts.pressStart2p(
                                                textStyle: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: isDay == false
                                                        ? Color.fromARGB(
                                                            255, 151, 194, 250)
                                                        : Colors.black),
                                              )),
                                        ],
                                      ),

                                      //weather animation
                                      Lottie.asset(getWeatherAnimation(
                                          _weather?.mainCondition, isDay)),

                                      //temperature
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.thermostat_outlined,
                                            color: isDay == false
                                                ? Color.fromARGB(
                                                    255, 151, 194, 250)
                                                : Colors.black,
                                            size: 50,
                                          ),
                                          Text(
                                            ('${_weather.temperature.round()}°C'),
                                            style: GoogleFonts.pressStart2p(
                                                textStyle: TextStyle(
                                                    fontSize: 35,
                                                    color: isDay == false
                                                        ? Color.fromARGB(
                                                            255, 151, 194, 250)
                                                        : Colors.black)),
                                          ),
                                        ],
                                      ),

                                      //weather conditions
                                      Text((_weather?.mainCondition) ?? "",
                                          style: GoogleFonts.pressStart2p(
                                              textStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: isDay == false
                                                      ? Color.fromARGB(
                                                          255, 151, 194, 250)
                                                      : Colors.black))),

                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //sunrise container
                                          BlurryContainer(
                                            blur: 5,
                                            width: 150,
                                            height: 150,
                                            elevation: 2,
                                            color: Colors.transparent,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/sunrise.png',
                                                  height: 60,
                                                  width: double.infinity,
                                                ),
                                                Text(
                                                  'dawn:',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Text(
                                                  (AppUtils()
                                                      .formatUnixToLocalTime(
                                                          _weather.sunrise
                                                              .round())),
                                                  style:
                                                      GoogleFonts.pressStart2p(
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              color: isDay ==
                                                                      true
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white)),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),
                                          //sunset container
                                          BlurryContainer(
                                            blur: 5,
                                            width: 150,
                                            height: 150,
                                            elevation: 2,
                                            color: Colors.transparent,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/sunset.png',
                                                  height: 50,
                                                  width: double.infinity,
                                                ),
                                                Text(
                                                  'dusk:',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Text(
                                                  (AppUtils()
                                                      .formatUnixToLocalTime(
                                                          _weather.sunset
                                                              .round())),
                                                  style:
                                                      GoogleFonts.pressStart2p(
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              color: isDay ==
                                                                      true
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                          ],
                        ),
                ]),
              ),
            ),
          ),
        ));
  }

  // Handle Search
  handleSearch(value) async {
    setState(() {
      isLoading = true;
    });
    var data = await WeatherServices().getWeatherWithCity(value, context);

    setState(() {
      _weather = data;
      isDay = AppUtils().getDayOrNightFromOffset(_weather.timeZone);
      isLoading = false;
    });
  }
}

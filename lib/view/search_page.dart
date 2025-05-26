import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/foundation.dart';
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
            color: Color(0xff243447),
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
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(children: [
                  // Search Textfield
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    style: TextStyle(
                        fontSize: 18,
                        color: isDay == false
                            ? Color.fromARGB(255, 151, 194, 250)
                            : Color(0xff243447)),
                    cursorColor: isDay == false
                        ? Color.fromARGB(255, 151, 194, 250)
                        : Color(0xff243447),
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
                                        : Color(0xff243447),
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
                                                : Color(0xff243447))),
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
                                          'Please enter a valid city name.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isDay == false
                                                ? Color.fromARGB(
                                                    255, 151, 194, 250)
                                                : Color(0xff243447),
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 50,
                                  ),
                            // Weather UI
                            _weather == null
                                ? SizedBox(
                                    height: 500,
                                    child: Center(
                                        child: Text(
                                      'no data',
                                      style: TextStyle(
                                          color: isDay == false
                                              ? Color.fromARGB(
                                                  255, 151, 194, 250)
                                              : Color(0xff243447)),
                                    )),
                                  )
                                : Column(
                                    children: [
                                      //city name

                                      Text(
                                        (_weather.cityName) ?? "",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400,
                                            color: isDay == false
                                                ? Color.fromARGB(
                                                    255, 151, 194, 250)
                                                : Color(0xff243447)),
                                      ),

                                      //temperature

                                      Text(
                                        ('${_weather.temperature.round()}°'),
                                        style: TextStyle(
                                            fontSize: 90,
                                            color: isDay == false
                                                ? Color.fromARGB(
                                                    255, 151, 194, 250)
                                                : Color(0xff243447)),
                                      ),

                                      //weather conditions
                                      Text((_weather?.mainCondition) ?? "",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: isDay == false
                                                ? Color.fromARGB(
                                                    255, 151, 194, 250)
                                                : Color(0xff243447),
                                            fontWeight: FontWeight.w600,
                                          )),

                                      //high low
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ('H:${_weather.tempMax.round()}°') ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                color: isDay == true
                                                    ? Color(0xff243447)
                                                    : Colors.white),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            ('L:${_weather.tempMin.round()}°') ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                color: isDay == true
                                                    ? Color(0xff243447)
                                                    : Colors.white),
                                          ),
                                        ],
                                      ),

                                      //feels like
                                      Text(
                                        ('Feels like: ${_weather.feelsLike.round()}°C'),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: isDay == true
                                                ? Color(0xff243447)
                                                : Colors.white),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      //weather animation
                                      BlurryContainer(
                                        blur: 5,
                                        width: double.infinity,
                                        height: 150,
                                        elevation: 1,
                                        color: Colors.transparent,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Condition Right now:',
                                              style: TextStyle(
                                                  color: isDay == true
                                                      ? Color(0xff243447)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Lottie.asset(
                                                getWeatherAnimation(
                                                    _weather?.mainCondition,
                                                    isDay),
                                                height: 100),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),

                                      //sunset sunrise
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //sunrise container
                                          Expanded(
                                            child: BlurryContainer(
                                              blur: 5,
                                              width: 150,
                                              height: 150,
                                              elevation: 2,
                                              color: Colors.transparent,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'dawn:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: isDay == false
                                                            ? Color.fromARGB(
                                                                255,
                                                                151,
                                                                194,
                                                                250)
                                                            : Color(
                                                                0xff243447)),
                                                  ),
                                                  Image.asset(
                                                    'assets/sunrise.png',
                                                    height: 70,
                                                    width: double.infinity,
                                                  ),
                                                  Text(
                                                    (AppUtils()
                                                        .formatUnixToLocalTime(
                                                            _weather.sunrise
                                                                .round())),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: isDay == true
                                                            ? Color(0xff243447)
                                                            : Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 20),
                                          //sunset container
                                          Expanded(
                                            child: BlurryContainer(
                                              blur: 5,
                                              width: 150,
                                              height: 150,
                                              elevation: 2,
                                              color: Colors.transparent,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'dusk:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: isDay == false
                                                            ? Color.fromARGB(
                                                                255,
                                                                151,
                                                                194,
                                                                250)
                                                            : Color(
                                                                0xff243447)),
                                                  ),
                                                  Image.asset(
                                                    'assets/sunset.png',
                                                    height: 70,
                                                    width: double.infinity,
                                                  ),
                                                  Text(
                                                    (AppUtils()
                                                        .formatUnixToLocalTime(
                                                            _weather.sunset
                                                                .round())),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: isDay == true
                                                            ? Color(0xff243447)
                                                            : Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),

                                      //wind
                                      BlurryContainer(
                                        blur: 5,
                                        width: double.infinity,
                                        height: 152,
                                        elevation: 1,
                                        color: Colors.transparent,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Wind:',
                                              style: TextStyle(
                                                  color: isDay == true
                                                      ? Color(0xff243447)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${_weather.windSpeed}',
                                                          style: TextStyle(
                                                              color: isDay ==
                                                                      true
                                                                  ? Color(
                                                                      0xff243447)
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 40),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text('KM/H',
                                                                style: TextStyle(
                                                                    color: isDay ==
                                                                            true
                                                                        ? Color(
                                                                            0xff243447)
                                                                        : Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            Text('wind',
                                                                style: TextStyle(
                                                                    color: isDay ==
                                                                            true
                                                                        ? Color(
                                                                            0xff243447)
                                                                        : Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      thickness: 2,
                                                      height: 2,
                                                      color: isDay == true
                                                          ? Color(0xff243447)
                                                          : Colors.white,
                                                    ),

                                                    //wind degree
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${_weather.windDeg}',
                                                          style: TextStyle(
                                                              color: isDay ==
                                                                      true
                                                                  ? Color(
                                                                      0xff243447)
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 40),
                                                        ),
                                                        Text(
                                                          'deg',
                                                          style: TextStyle(
                                                              color: isDay ==
                                                                      true
                                                                  ? Color(
                                                                      0xff243447)
                                                                  : Colors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                Image.asset(
                                                  'assets/compass.png',
                                                  height: 110,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),
                                      //humidity pressure
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //humidity container
                                          Expanded(
                                            child: BlurryContainer(
                                              blur: 5,
                                              width: 150,
                                              height: 150,
                                              elevation: 1,
                                              color: Colors.transparent,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Humidity',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: isDay == true
                                                            ? Color(0xff243447)
                                                            : Colors.white),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Text(
                                                    ('${_weather.humidity}%') ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        color: isDay == true
                                                            ? Color(0xff243447)
                                                            : Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 20,
                                          ),
                                          //Pressure container
                                          Expanded(
                                            child: BlurryContainer(
                                              blur: 5,
                                              width: 150,
                                              height: 150,
                                              elevation: 1,
                                              color: Colors.transparent,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Pressure',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: isDay == true
                                                            ? Color(0xff243447)
                                                            : Colors.white),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        (_weather.pressure),
                                                        style: TextStyle(
                                                            fontSize: 40,
                                                            color: isDay == true
                                                                ? Color(
                                                                    0xff243447)
                                                                : Colors.white),
                                                      ),
                                                      Text(
                                                        'hPa',
                                                        style: TextStyle(
                                                            color: isDay == true
                                                                ? Color(
                                                                    0xff243447)
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 20),
                                      //visibility
                                      BlurryContainer(
                                        blur: 5,
                                        width: double.infinity,
                                        height: 150,
                                        elevation: 1,
                                        color: Colors.transparent,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Visibility',
                                              style: TextStyle(
                                                  color: isDay == true
                                                      ? Color(0xff243447)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Lottie.asset(
                                                      'assets/visibility.json',
                                                      height: 100),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  AppUtils().formatVisibilityKm(
                                                      _weather.visibility),
                                                  style: TextStyle(
                                                      color: isDay == true
                                                          ? Color(0xff243447)
                                                          : Colors.white,
                                                      fontSize: 40),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
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

    if (data != null) {
      setState(() {
        _weather = data;
        isDay = AppUtils().getDayOrNightFromOffset(_weather.timeZone);
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}

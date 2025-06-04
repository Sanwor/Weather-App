import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/app_config/utils.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/view/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//textediting controller
  TextEditingController searchController = TextEditingController();

//api key
  final _weatherService = WeatherServices();
  dynamic _weather;
  var time = DateTime.now().hour;

  bool isLoading = true;

//fetch data
  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
      });
    }
    //incase of any error
    catch (e) {
      debugPrint(e.toString());
    }
  }

//weather animation
  String getWeatherAnimation(String? mainCondition) {
    final hour = DateTime.now().hour;
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return hour >= 6 && hour < 18
            ? 'assets/sunny.json'
            : 'assets/night.json';

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

//init state
  @override
  void initState() {
    super.initState();
    //fetch weather on startup
    initialise();
  }

  initialise() async {
    setState(() {
      isLoading = true;
    });
    await _fetchWeather();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 85, 152, 239), // light sky blue
                      Color(0xFFF0F9FF), // very light blue/white
                    ],
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xff243447),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Loading...',
                              style: GoogleFonts.pressStart2p(
                                textStyle: TextStyle(
                                    fontSize: 12, color: Color(0xff243447)),
                              ))
                        ],
                      ))
                    ]),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: time >= 6 && time < 18
                        ? [
                            Color.fromRGBO(98, 161, 242, 1), // light sky blue
                            Color.fromRGBO(186, 215, 254, 1),
                          ]
                        : [
                            Color.fromARGB(255, 2, 18, 38), // light sky blue
                            Color.fromARGB(
                                255, 32, 68, 134), // very light blue/white
                          ]),
              ),
              child: Column(
                children: [
                  //searchbar
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchPage()));
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, top: 50, bottom: 20),
                        child: Container(
                          height: 60,
                          width: 350,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: time >= 6 && time < 18
                                    ? Color.fromARGB(255, 178, 199, 225)
                                    : Color.fromARGB(255, 151, 194, 250)),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: Checkbox.width, left: Checkbox.width),
                            child: Text(
                              'search',
                              style: TextStyle(shadows: <Shadow>[
                                Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 35.0,
                                    color: Colors.blueGrey),
                              ], color: Colors.white, fontSize: 15),
                            ),
                          ),
                        )),
                  ),
                  // Body Content
                  Expanded(
                    child: RefreshIndicator(
                      color: Color(0xff243447),
                      onRefresh: () async {
                        return await Future.delayed(const Duration(seconds: 1),
                            () {
                          initialise();
                        });
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _weather == null
                                ? SizedBox(
                                    height: 500,
                                    child: Text("No Data Found"),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Text(
                                          'My Location',
                                          style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 35.0,
                                                    color: Colors.blueGrey),
                                              ],
                                              fontSize: 30,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),

                                        // city name
                                        Text(
                                          (_weather?.cityName) ?? "",
                                          style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 35.0,
                                                    color: Colors.blueGrey),
                                              ],
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),

                                        //temperature
                                        Text(
                                          ('${_weather.temperature.round()}°'),
                                          style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 35.0,
                                                    color: Colors.blueGrey),
                                              ],
                                              fontWeight: FontWeight.normal,
                                              fontSize: 90,
                                              color: Colors.white),
                                        ),

                                        //weather conditions
                                        Text(
                                          (_weather?.mainCondition) ?? "",
                                          style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 20.0,
                                                    color: Colors.blueGrey),
                                              ],
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),

                                        //High Low
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ('H:${_weather.tempMax.round()}°'),
                                              style: TextStyle(
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                        offset:
                                                            Offset(2.0, 2.0),
                                                        blurRadius: 35.0,
                                                        color: Colors.blueGrey),
                                                  ],
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              ('L:${_weather.tempMin.round()}°'),
                                              style: TextStyle(
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                        offset:
                                                            Offset(2.0, 2.0),
                                                        blurRadius: 35.0,
                                                        color: Colors.blueGrey),
                                                  ],
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),

                                        //feels like
                                        Text(
                                          ('Feels like: ${_weather.feelsLike.round()}°C'),
                                          style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 35.0,
                                                    color: Colors.blueGrey),
                                              ],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.white),
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
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Lottie.asset(
                                                  getWeatherAnimation(
                                                      _weather?.mainCondition),
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
                                                elevation: 1,
                                                color: Colors.transparent,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'dawn:',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
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
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              width: 20,
                                            ),
                                            //sunset container
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
                                                      'dusk:',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
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
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
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
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 40),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text('KM/H',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              Text('wind',
                                                                  style: TextStyle(
                                                                      color: Colors
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
                                                        color: Colors.white,
                                                      ),

                                                      //wind degree
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${_weather.windDeg}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 40),
                                                          ),
                                                          Text(
                                                            'deg',
                                                            style: TextStyle(
                                                                color: Colors
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
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/compass.png',
                                                        height: 110,
                                                      ),
                                                      Transform.rotate(
                                                          angle:
                                                              _weather.windDeg,
                                                          child: Image.asset(
                                                            'assets/arrow.png',
                                                            height: 25,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 20),

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
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      ('${_weather.humidity}%'), //<==========================================================
                                                      style: TextStyle(
                                                          fontSize: 40,
                                                          color: Colors.white),
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
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          (_weather.pressure),
                                                          style: TextStyle(
                                                              fontSize: 40,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          'hPa',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                    AppUtils()
                                                        .formatVisibilityKm(
                                                            _weather
                                                                .visibility),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Loading...',
                            style: GoogleFonts.pressStart2p(
                                textStyle: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          )
                        ],
                      ))
                    ]),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: time >= 6 && time < 18
                        ? [
                            Color.fromARGB(
                                255, 151, 194, 250), // light sky blue
                            Color(0xFFF0F9FF), // very light blue/white
                          ]
                        : [
                            Color.fromARGB(255, 2, 18, 38), // light sky blue
                            Color.fromARGB(255, 32, 68, 134), // very light blue/white
                          ]),
              ),
              child: RefreshIndicator(
                color: Colors.black,
                onRefresh: () async {
                  return await Future.delayed(const Duration(seconds: 1), () {
                    initialise();
                  });
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //searchbar
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchPage()));
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 50, bottom: 100),
                              child: Container(
                                height: 60,
                                width: 350,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: time >= 6 && time < 18
                                          ? Colors.black
                                          : Color.fromARGB(255, 151, 194, 250)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  color: Colors.transparent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: Checkbox.width,
                                      left: Checkbox.width),
                                  child: Text(
                                    'search',
                                    style: GoogleFonts.pressStart2p(
                                        textStyle: TextStyle(
                                            color: time >= 6 && time < 18
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 10)),
                                  ),
                                ),
                              )),
                        ),

                        Text('My Location',
                            style: GoogleFonts.pressStart2p(
                              textStyle: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: time >= 6 && time < 18
                                      ? Colors.black87
                                      : Colors.white),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        //city name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: const Color.fromARGB(255, 236, 24, 9),
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text((_weather.cityName),
                                style: GoogleFonts.pressStart2p(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: time >= 6 && time < 18
                                          ? Colors.black87
                                          : Colors.white),
                                )),
                          ],
                        ),

                        //weather animation
                        Lottie.asset(
                            getWeatherAnimation(_weather?.mainCondition)),

                        //temperature
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thermostat_outlined,
                              color: time >= 6 && time < 18
                                  ? Colors.black
                                  : Colors.white,
                              size: 50,
                            ),
                            Text(
                              ('${_weather.temperature.round()}°C'),
                              style: GoogleFonts.pressStart2p(
                                  textStyle: TextStyle(
                                      fontSize: 35,
                                      color: time >= 6 && time < 18
                                          ? Colors.black
                                          : Colors.white)),
                            ),
                          ],
                        ),

                        //weather conditions
                        Text(
                          (_weather?.mainCondition) ?? "",
                          style: GoogleFonts.pressStart2p(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: time >= 6 && time < 18
                                      ? Colors.black
                                      : Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

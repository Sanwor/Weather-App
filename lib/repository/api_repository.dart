import 'package:http/http.dart' as http;
import 'package:weather_app/app_config/constant.dart';
import 'package:weather_app/services/weather_services.dart';

class ApiRepo {
  // Get Base Url
  var baseUrl = AppConstant().baseUrl;

  get(path) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl$path"));
      if (response.statusCode == 200) {
        return response;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
    }
  }

  post(path) async {
    await http.post(Uri.parse("$baseUrl$path"));
  }
}

import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  checkInitialConnectivity() async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      try {
        var response = await http
            .get(Uri.parse("http://clients3.google.com/generate_204"))
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 204) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }
}

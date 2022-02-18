import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHandler {
  static String BACKEND_ENDPOINT =
      "https://v49efc8t28.execute-api.us-east-1.amazonaws.com/alpha/masterRouter";

  Future<Map<dynamic, dynamic>> callAPI(
      API api, Map<dynamic, dynamic> json) async {
    final response = await http.post(Uri.parse(BACKEND_ENDPOINT),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*'
        },
        body: jsonEncode(APIExtension.appendJsonKeyBasedOnAPI(api, json)));
    print(api.name+" "+jsonEncode(APIExtension.appendJsonKeyBasedOnAPI(api, json)));
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }
}

enum API {
  API_NEW_ORDERS,
  API_UPDATE_ORDER
}

extension APIExtension on API {
  static Map<dynamic, dynamic> appendJsonKeyBasedOnAPI(
      API api, Map<dynamic, dynamic> json) {
    return {getKeyForAPI(api): json};
  }

  static String getKeyForAPI(API api) {
    String key = "";
    switch (api) {
      case API.API_NEW_ORDERS:
        key = "fetchNewOrderRequest";
        break;
      case API.API_UPDATE_ORDER:
        key = "orderUpdateRequest";
        break;
    }
    return key;
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:iotmqttapinetpie/model/model.dart';

class NETPIE2020 {
  // publish message topic
  Future<bool> publish(
      String topic, String clientId, String token, String message) async {
    // send request token
    String deviceAuth = 'Device $clientId:$token';
    String url = "https://api.netpie.io/v2/device/message?topic=lab_ict_kps/command";
    Response response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Authorization': deviceAuth,
        },
        body: message);
    log("statusCode -> " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // read data from shadow
  Future<Device> readShadow(String clientId, String token) async {
    // send request token
    String deviceAuth = 'Device $clientId:$token';
    String url = "https://api.netpie.io/v2/device/shadow/data";
    Response response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Authorization': deviceAuth,
      },
    );
    log("statusCode -> " + response.statusCode.toString());
    log("jsonBody -> " + response.body.toString());
    if (response.statusCode == 200) {
      // Parse JSON response and return Device object
      return Device.fromJson(json.decode(response.body));
    } else {
      // Handle error response, you might want to throw an exception here or handle it differently based on your use case.
      throw Exception('Failed to load device data');
    }
  }
}


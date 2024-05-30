import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iotmqttapinetpie/service/netpie2020.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _deviceID = "dbcd1612-6619-49cf-acc1-ded83aa82946";
  String _deviceToken = "XeH8bm7UNCJHb2A4WZhQgZPNishUPKGc";

  late NETPIE2020 netpie2020;

  bool _led = false;
  double _temp = 0.0;
  double _humid = 0.0;
  double _ultrasonicDistance = 0.0;
  int _timestamp = 0;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Initialize NETPIE2020 instance
    netpie2020 = NETPIE2020();
    // Fetch initial data
    fetchData();
    // Start periodic timer to fetch data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchData());
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  // Method to fetch data from API
void fetchData() {
  netpie2020.readShadow(_deviceID, _deviceToken).then((value) {
    // Update state variables with fetched data
    setState(() {
      _temp = value.data.temperature;
      _humid = value.data.humidity;
      _ultrasonicDistance = value.data.ultrasonic_distance;
      _led = value.data.red_led == 1;
      _timestamp = value.timestamp;
    });
  }).catchError((error) {
    // Handle error, such as displaying an error message
    print('Error fetching data: $error');
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NETPIE2020"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _led
                  ? SizedBox(width: 220, child: Image.asset("assets/images/ledon.png"))
                  : SizedBox(width: 220, child: Image.asset("assets/images/ledoff.png")),
              ElevatedButton(
                child: Text("ON"),
                onPressed: () {
                  // set led on
                  netpie2020.publish("red_led", _deviceID, _deviceToken, "RED_ON").then((res) {
                    if (res) {
                      setState(() {
                        _led = true;
                      });
                    }
                  });
                },
              ),
              ElevatedButton(
                child: Text("OFF"),
                onPressed: () {
                  // set led off
                  netpie2020.publish("red_led", _deviceID, _deviceToken, "RED_OFF").then((res) {
                    if (res) {
                      setState(() {
                        _led = false;
                      });
                    }
                  });
                },
              ),
              Text("Temp = $_temp °C"),
              Text("Humid = $_humid %"),
              Text("Ultrasonic Distance = $_ultrasonicDistance m."),
              Text("Timestamp = $_timestamp"),
            ],
          ),
        ),
      ),
    );
  }
}

class Device {
  String deviceid;
  Data data;
  int rev;
  int timestamp;
  int modified;

  Device({
    required this.deviceid,
    required this.data,
    required this.rev,
    required this.timestamp,
    required this.modified,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceid: json['deviceid'],
      data: Data.fromJson(json['data']),
      rev: json['rev'],
      timestamp: json['timestamp'],
      modified: json['modified'],
    );
  }
}

class Data {
  int red_led;
  double temperature;
  double humidity;
  double ultrasonic_distance;

  Data({
    required this.red_led,
    required this.temperature,
    required this.humidity,
    required this.ultrasonic_distance,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
  return Data(
    red_led: json['red_led'] as int,
    temperature: json['temperature'].toDouble(), // Parse as double
    humidity: json['humidity'].toDouble(), // Parse as double
    ultrasonic_distance: json['ultrasonic_distance'].toDouble(),
  );
}
}


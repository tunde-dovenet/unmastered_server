import 'package:unmastered_server/solution/contacts/models/converters.dart';

class WeatherData {
  final DateTime date;
  final String name;
  final double temperature;
  final String main;
  final String icon;

  WeatherData({this.date, this.name, this.temperature, this.main, this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final weathertemp = json['main'];
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false),
      name: json['name'],
      temperature: weathertemp['temp'].toDouble(),
      main: weather['main'],
      icon: weather['icon'],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unmastered_server/solution/contacts/provider/weatherData.dart';

class WeatherItemSms extends StatelessWidget {
  final WeatherData weather;

  WeatherItemSms({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          this.weather.name.toUpperCase(),
          style: new TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 5,
            color: Theme.of(context).accentColor,
            fontSize: 15,
          ),
        ),
        Text(
          weather.main,
          style: new TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 32.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          '${this.weather.temperature}°',
          style: new TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          new DateFormat.yMMMd().format(weather.date),
          style: new TextStyle(
            color: Theme.of(context).accentColor.withAlpha(90),
          ),
        ),
        Text(
          new DateFormat.Hm().format(weather.date),
          style: new TextStyle(
            color: Theme.of(context).accentColor.withAlpha(90),
          ),
        ),
      ],
    );
  }
}

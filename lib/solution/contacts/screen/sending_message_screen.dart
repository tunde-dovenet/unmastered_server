import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';
import 'package:unmastered_server/solution/contacts/provider/weatherData.dart';
import 'package:unmastered_server/solution/contacts/widgets/contact_item.dart';
import 'package:unmastered_server/solution/contacts/widgets/weather_item.dart';

class SendMessageScreen extends StatefulWidget {
  static const routeName = '/send-message';
  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final _form = GlobalKey<FormState>();

  WeatherData weatherData;
  String _name;
  String _main;
  String _description;
  double _temperature;

  

  final todayIs = DateFormat.yMMMd('en_US').format(DateTime.now());

  final _phoneNumberFocusNode = FocusNode();
  final _weatherFocusNode = FocusNode();
  final _phoneNumberController = TextEditingController();
  final _weatherController = TextEditingController();
  var _isLoading = false;

  @override
  void initState() {
    _weatherFocusNode.addListener(_updateWeather);
    super.initState();
  }

  @override
  void dispose() {
    _weatherFocusNode.removeListener(_updateWeather);
    _weatherFocusNode.dispose();
    _weatherController.dispose();
    _phoneNumberController.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _updateWeather() {
    if (!_weatherFocusNode.hasFocus) {
      if (!_weatherController.text.isNotEmpty) return;
    }
    setState(() {});
  }

  // Future<void> _sendForm() async {
  //   final isValid = _form.currentState.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   _form.currentState.save();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     const from = 'Saroafrica International LTD.';
  //     String url = 'https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=q1rR9sw7dWDf38RYsUCw6oR7UbHbytDk1Akke2nRMnpBB1L9I37jS2SaIOm2&from=$from&to=08103473127&body=WeatherNotification';
  //     http.Response response = await http.get(
  //       Uri.encodeFull(url),
  //       headers: {
  //         'Accept': 'Application/json'
  //       }
  //     );
  //     print(json.decode(response.body));

  //   } catch (error) {
  //     await showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         title: Text('A function is meant to occur'),
  //         content: Text('Go met your developer boy :('),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Okay'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   Navigator.of(context).pop();
  // }

  _fetchWeatherWithCity(cityName) async {
    setState(() {
      _isLoading = true;
      _weatherController.text = cityName;
    });

    final apiKey = '934ff8d259a32f240b83244afaa95ec2';
    final baseURLweather = 'https://api.openweathermap.org/data/2.5/weather?q=';

    final finalURLweather = baseURLweather + cityName + '&' + 'APPID=' + apiKey;

    final weatherResponse = await http.get(finalURLweather);

    print(jsonDecode(weatherResponse.body));
    final extractedWeatherData = json.decode(weatherResponse.body);

    if (weatherResponse.statusCode == 200) {
      return setState(() {
        weatherData = WeatherData.fromJson(jsonDecode(weatherResponse.body));
        _name = extractedWeatherData['name'];
        _main = extractedWeatherData['weather'][0]['main'];
        _description = extractedWeatherData['weather'][0]['description'];
        _temperature = extractedWeatherData['main']['temp'].toDouble();
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactId = ModalRoute.of(context).settings.arguments as String;
    final loadContact = Provider.of<Contacts>(
      context,
      listen: false,
    ).findById(contactId);
    final String _inItValue = loadContact.phone.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Message' + ' ' + loadContact.fName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _inItValue,
                decoration: InputDecoration(labelText: 'Phone Number'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_weatherFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
                onSaved: (value) {
                  value = value;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.green,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _weatherController.text.isEmpty
                          ? Text('Enter a location')
                          : FittedBox(
                              child: Weather(
                                weather: weatherData,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Location'),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      controller: _weatherController,
                      focusNode: _weatherFocusNode,
                      onFieldSubmitted: (value) {
                        _fetchWeatherWithCity(value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Location';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        value = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      highlightedBorderColor: Colors.green,
                      onPressed: () async {
                        final isValid = _form.currentState.validate();
                        if (!isValid) {
                          return;
                        }
                        _form.currentState.save();
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          const from = 'Saroafrica';
                          const from2 = 'International';
                          const from3 = 'LTD.';

                          final phone = _inItValue;
                          final test4 = _name;
                          final test5 = _temperature - 273.15;
                          final test6 = _description;

                          String url =
                              'https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=q1rR9sw7dWDf38RYsUCw6oR7UbHbytDk1Akke2nRMnpBB1L9I37jS2SaIOm2&from=$from+$from2+$from3&to=$phone&body=Today+is+$todayIs.+It+is+$test5+degrees+in+$test4+-+$test6.';
                          http.Response response = await http.get(
                            Uri.encodeFull(url),
                            headers: {'Accept': 'Application/json'},
                          );
                          print(
                            json.decode(response.body),
                          );
                        } catch (error) {
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Something Happend'),
                              content: Text(
                                  'Try again later, huh!'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Send'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';

class Contact with ChangeNotifier {
  final String id;
  final String fName;
  final String lName;
  final int phone;
  final String state;
  final String lGA;
  final String email;

  Contact({
    @required this.id,
    @required this.fName,
    @required this.lName,
    @required this.phone,
    @required this.state,
    @required this.lGA,
    @required this.email,
  });

  int get phoneNumber {
    return phone;
  }
}

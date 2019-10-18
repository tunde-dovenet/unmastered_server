import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class ShowSelectModal extends StatefulWidget {
  @override
  _ShowSelectModalState createState() => _ShowSelectModalState();
}

class _ShowSelectModalState extends State<ShowSelectModal> {
  final _formKey = GlobalKey<FormState>();
  List _myChoice;

  @override
  void initState() {
    super.initState();
    _myChoice = [];
  }

  _saveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
       // 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            child: MultiSelectFormField(
              autovalidate: false,
              titleText: 'Select based on the location',
              validator: (value) {
                if (value == null || value.length == 0) {
                  return 'Please select one or more options';
                }
              },
              dataSource: [
                {
                  'display': 'Lagos',
                  'value': 'Lagos'
                },
                {
                  'display': 'Kano',
                  'value': 'Kano',
                },
                {
                  'display': 'Kaduna',
                  'value': 'Kaduna'
                }
              ],
              textField: 'display',
              valueField: 'value',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              hintText: 'Select one for now',
              value: _myChoice,
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                 _myChoice = value; 
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
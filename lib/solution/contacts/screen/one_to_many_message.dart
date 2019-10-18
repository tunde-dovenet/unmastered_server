import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contact.dart';

class OneToManyMessage extends StatefulWidget {
  static const routeName = '/one-to-many';

  @override
  _OneToManyMessageState createState() => _OneToManyMessageState();
}

class _OneToManyMessageState extends State<OneToManyMessage> {
  final _theMessage = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _theMessage.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // final contactNumber = ModalRoute.of(context).settings.arguments as String;
    final phone = Provider.of<Contact>(context, listen: false).phoneNumber;
    return Scaffold(
      appBar: AppBar(
        title: Text('One to Many'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: phone.toString(),
                decoration: InputDecoration(labelText: 'Enter a number'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a number';
                  }
                  if (value.length <= 10) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter you desirable message'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                controller: _theMessage,
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This can not be enter';
                  }
                  if (value.length <= 9) {
                    return 'Enter a valid message';
                  }
                },
              ),
              Row(
                    children: <Widget>[
                      const Spacer(),
                      OutlineButton(
                        highlightedBorderColor: Colors.green,
                        onPressed: () {},
                        child: const Text('Send'),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
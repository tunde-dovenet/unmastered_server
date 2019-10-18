import 'package:flutter/material.dart';

class ShowState extends StatelessWidget {
  final String id;
  final String fName;
  final String lName;
  final String state;

  const ShowState(this.id, this.fName, this.lName, this.state);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: FittedBox(
                child: Text(
                  fName,
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ),
        ),
        title: Text(fName + ' ' + lName),
        subtitle: Text(state),
    );
  }
}
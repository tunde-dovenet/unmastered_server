import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';

import 'sending_message_screen.dart';

enum FilterOptions { Select, SelectAll, CustomizeView }

class ContactDetailScreen extends StatefulWidget {
  static const routeName = '/contact-detail';

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  var _showSelect = false;

  RectTween _createRectTween(Rect begin, Rect end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  @override
  Widget build(BuildContext context) {
    final contactId = ModalRoute.of(context).settings.arguments as String;
    final loadedContact = Provider.of<Contacts>(context).findById(contactId);
    
    Widget _showContactDetails() {
      return ListView(
        children: <Widget>[
          SizedBox(
            child: Hero(
              createRectTween: _createRectTween,
              tag: loadedContact.id,
              child: Container(
                color: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: FittedBox(
                        child: Text(
                          loadedContact.fName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            height: 250.0,
          ),
          ListTile(
            title: Text(
              loadedContact.phone.toString(),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.green[400],
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              loadedContact.email,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.green[400],
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              loadedContact.state,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.location_city,
              color: Colors.green[400],
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              loadedContact.lGA,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.location_searching,
              color: Colors.green[400],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 22.0
          )
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Details for ' + loadedContact.fName,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _showContactDetails(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
                    .pushNamed(SendMessageScreen.routeName, arguments: loadedContact.id);
        },
        icon: Icon(Icons.cloud),
        label: Text('Send Weather Info ' + 'to '+ loadedContact.fName),
        backgroundColor: Colors.black,
      ),
    );
  }
}

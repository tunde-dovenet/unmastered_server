import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contact.dart';
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';
import 'package:unmastered_server/solution/contacts/screen/one_to_many_message.dart';
import 'package:unmastered_server/solution/contacts/screen/user_contacts_screen.dart';
import 'package:unmastered_server/solution/contacts/widgets/app_drawer.dart';
import 'package:unmastered_server/solution/contacts/widgets/contacts_list.dart';

import 'sending_message_screen.dart';

enum FilterOptions { Select, SelectAll }

class ContactOverviewScreen extends StatefulWidget {
  _ContactOverviewScreenState createState() => _ContactOverviewScreenState();
}

class _ContactOverviewScreenState extends State<ContactOverviewScreen> {
  var _showSelect = false;
  var _isInit = true;
  var _isLoading = false;
  var _isSelected = false;
  List _mySelection;
  ScrollController scrollController;
  bool _dialVisible = true;

  void setDialVisible(bool value) {
    setState(() {
      _dialVisible = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _mySelection = [];
    
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Contacts>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 4,
        brightness: Brightness.dark,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Select) {
                  _showSelect = true;
                  _isSelected = true;
                } else {
                  _showSelect = false;
                  _isSelected = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('SMS'),
                value: FilterOptions.Select,
              ),
              PopupMenuItem(
                child: Text('WEATHER'),
                value: FilterOptions.SelectAll,
              ),
            ],
          ),
          FittedBox(
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/saro.jpg'),
              backgroundColor: Colors.white,
              radius: 20,
            ),
          )
        ],
        title: FlatButton(
          child: Text(
            'Search List',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {},
        ),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListContact(),
      floatingActionButton: _isSelected ? FloatingActionButton.extended(
        onPressed: () {
          //Navigator.of(context).pushNamed(OneToManyMessage.routeName, arguments: phone);
        },
        icon: Icon(Icons.sms),
        label: Text('Send SMS'),
        backgroundColor: Colors.green,
      ) : 
      FloatingActionButton.extended(
        onPressed: () {
          // Navigator.of(context)
          //           .pushNamed(SendMessageScreen.routeName);
        },
        icon: Icon(Icons.cloud),
        label: Text('Send WEATHER'),
        backgroundColor: Colors.grey,
      )
    );
  }
}

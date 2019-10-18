import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/auth/auth.dart';
import 'package:unmastered_server/solution/contacts/screen/unmastered_screen.dart';
import 'package:unmastered_server/solution/contacts/screen/user_contacts_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.white,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Image.asset('assets/saro.jpg'),
                ),
              ),
            ),
            title: Text(
              'Customer!',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text('Customers'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Manage Contacts'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserContactsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.send),
            title: Text('Unmastered Screen'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UnmasteredScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context).logout();
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';
import 'package:unmastered_server/solution/contacts/screen/create_new_contact.dart';

class UserContactItem extends StatelessWidget {
  final String id;
  final String fName;
  final String lName;

  UserContactItem(this.id, this.fName, this.lName);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(fName + ' ' + lName),
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
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CreateNewContactForm.routeName, arguments: id);
              },
              color: Theme.of(context).accentColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Contacts>(context, listen: false).deleteContacts(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting failed!', textAlign: TextAlign.center,),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}

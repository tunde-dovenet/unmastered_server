import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contact.dart';
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';
import 'package:unmastered_server/solution/contacts/screen/contact_detail_screen.dart';

class ContactItem extends StatefulWidget {
  final String id;

  // final String listId;

  const ContactItem(this.id);

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  var _isSelected = false;
  var _cardColor = Colors.white;
  List<dynamic> _mySelection;

  List get mySelecetedList{
    return _mySelection;
  }

  @override
  void initState() {
    _mySelection = [];
    super.initState();
  }

  Future<void> toggleSelection(BuildContext context) async {
    if (_isSelected) {
      _cardColor = Colors.white;
      _isSelected = false;
    } else {
      _isSelected = true;
      _cardColor = Colors.grey[300];
      Provider.of<Contact>(context, listen: false).phoneNumber;
    }
  }

  _toggleSelection() {
    setState(() {
      if (_isSelected) {
        _cardColor = Colors.white;
        _isSelected = false;
      } else {
        _cardColor = Colors.grey[600];
        _isSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contact = Provider.of<Contact>(context);
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                'Do you want to remove ' + contact.fName + ' from the list?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              )
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        try {
          await Provider.of<Contacts>(context, listen: false)
              .deleteContacts(widget.id);
        } catch (error) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Deleting failed!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: _cardColor,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(ContactDetailScreen.routeName,
                    arguments: contact.id);
              },
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ContactDetailScreen.routeName,
                          arguments: contact.id);
                    },
                    child: FittedBox(
                      child: Text(
                        contact.fName,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(contact.fName + ' ' + contact.lName),
              subtitle: Text(contact.email),
              onLongPress: () {
                setState(() {
                  if (_isSelected) {
                    _cardColor = Colors.white;
                    _isSelected = false;
                  } else {
                    _cardColor = Colors.grey[600];
                    _isSelected = true;
                    _mySelection.add(contact.phoneNumber);
                    _mySelection.add(contact.state);
                    print(_mySelection);
                  }
                });
              }),
        ),
      ),
    );
  }
}

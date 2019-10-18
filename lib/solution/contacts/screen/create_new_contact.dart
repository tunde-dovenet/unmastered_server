import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contact.dart';
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';

class CreateNewContactForm extends StatefulWidget {
  static const routeName = '/contact-edit-add';

  @override
  _CreateNewContactFormState createState() => _CreateNewContactFormState();
}

class _CreateNewContactFormState extends State<CreateNewContactForm> {
  
  final _lastNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _stateFocusNode = FocusNode();
  final _lGAFocusNode = FocusNode();
  final _eMailFocusMode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = true;
  var _isLoading = false;

  var _editContact = Contact(
    id: null,
    fName: '',
    lName: '',
    phone: 00,
    state: '',
    lGA: '',
    email: '',
  );
  var _initValues = {
    'firstName': '',
    'lastName': '',
    'phoneNumber': '',
    'state': '',
    'lGA': '',
    'eMail': '',
  };
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final contactId = ModalRoute.of(context).settings.arguments as String;
      if (contactId != null) {
        _editContact =
            Provider.of<Contacts>(context, listen: false).findById(contactId);
        _initValues = {
          'firstName': _editContact.fName,
          'lastName': _editContact.lName,
          'phoneNumber': _editContact.phone.toString(),
          'state': _editContact.state,
          'lGA': _editContact.lGA,
          'eMail': _editContact.email
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() { 
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _stateFocusNode.dispose();
    _lGAFocusNode.dispose();
    _eMailFocusMode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editContact.id != null) {
      await Provider.of<Contacts>(context, listen: false)
          .updateContact(_editContact.id, _editContact);
    } else {
      try {
        await Provider.of<Contacts>(context, listen: false)
            .addContact(_editContact);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: _initValues['firstName'],
                    decoration: const InputDecoration(
                      labelText: 'First name',
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_lastNameFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editContact = Contact(
                        fName: value,
                        lName: _editContact.lName,
                        phone: _editContact.phone,
                        state: _editContact.state,
                        id: _editContact.id,
                        lGA: _editContact.lGA,
                        email: _editContact.email
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                    ),
                    initialValue: _initValues['lastName'],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_phoneFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editContact = Contact(
                        fName: _editContact.fName,
                        lName: value,
                        phone: _editContact.phone,
                        state: _editContact.state,
                        lGA: _editContact.lGA,
                        id: _editContact.id,
                        email: _editContact.email
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: _initValues['phoneNumber'],
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_stateFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Number is required';
                      }
                      if (value.length < 11) {
                        return 'Enter a valid number';
                      }
                      if (value.length > 11) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editContact = Contact(
                        fName: _editContact.fName,
                        lName: _editContact.lName,
                        phone: int.parse(value),
                        state: _editContact.state,
                        lGA: _editContact.lGA,
                        id: _editContact.id,
                        email: _editContact.email
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: _initValues['state'],
                    decoration: const InputDecoration(
                      labelText: 'State',
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_lGAFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'State is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editContact = Contact(
                        id: _editContact.id,
                        fName: _editContact.fName,
                        lName: _editContact.lName,
                        phone: _editContact.phone,
                        state: value,
                        lGA: _editContact.lGA,
                        email: _editContact.email
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: _initValues['lGA'],
                    decoration: const InputDecoration(
                      labelText: 'L.G.A',
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_eMailFocusMode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'L.G.A is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editContact = Contact(
                        id: _editContact.id,
                        fName: _editContact.fName,
                        lName: _editContact.lName,
                        phone: _editContact.phone,
                        state: _editContact.state,
                        lGA: value,
                        email: _editContact.email
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: _initValues['eMail'],
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    focusNode: _eMailFocusMode,
                    maxLines: 3,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Address is required';
                      }
                      if (value.length < 10) {
                        return 'Should be at 10 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editContact = Contact(
                        id: _editContact.id,
                        fName: _editContact.fName,
                        lName: _editContact.lName,
                        phone: _editContact.phone,
                        state: _editContact.state,
                        lGA: _editContact.lGA,
                        email: value
                      );
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _agreedToTOS,
                        onChanged: _setAgreedToTOS,
                      ),
                      GestureDetector(
                        onTap: () => _setAgreedToTOS(!_agreedToTOS),
                        child: const Text(
                          'Does this customer accept the Terms of Services',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      OutlineButton(
                        highlightedBorderColor: Colors.green,
                        onPressed: _submittable() ? _saveForm : null,
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    ));
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}

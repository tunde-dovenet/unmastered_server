import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';
import 'package:unmastered_server/solution/contacts/widgets/show_states.dart';

class ListSelected extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final contactData = Provider.of<Contacts>(context);
    final contact = contactData.items;
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: contact.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: contact[index],
        child: ShowState(
          contact[index].id,
          contact[index].fName,
          contact[index].lName,
          contact[index].state
        ),
      ),
    );
  }
}

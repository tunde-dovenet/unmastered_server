import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';
import 'package:unmastered_server/solution/contacts/screen/create_new_contact.dart';
import 'package:unmastered_server/solution/contacts/widgets/app_drawer.dart';
import 'package:unmastered_server/solution/contacts/widgets/user_contact_item.dart';

class UserContactsScreen extends StatefulWidget {
  static const routeName = '/user-contacts';

  @override
  _UserContactsScreenState createState() => _UserContactsScreenState();
}

class _UserContactsScreenState extends State<UserContactsScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Contacts>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(CreateNewContactForm.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Contacts>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserContactItem(
                                productsData.items[i].id,
                                productsData.items[i].fName,
                                productsData.items[i].lName,
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

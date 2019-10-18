import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/provider/contacts.dart';
import 'package:unmastered_server/solution/contacts/widgets/app_drawer.dart';
import 'package:unmastered_server/solution/contacts/widgets/list_selected.dart';
import 'package:unmastered_server/solution/contacts/widgets/show_states.dart';

class UnmasteredScreen extends StatefulWidget {
  static const routeName = '/unmastered-screen';

  @override
  _UnmasteredScreenState createState() => _UnmasteredScreenState();
}

class _UnmasteredScreenState extends State<UnmasteredScreen> {
  // var _isInit = true;
  var _isLoading = false;

  final _locationController = TextEditingController();

  @override
  void dispose() { 
    _locationController.dispose();
    super.dispose();
  }
  
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     _isLoading = true;
  //     Provider.of<Contacts>(context).filterLocation().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  Future<void> _searchShit(BuildContext context) async {
    await Provider.of<Contacts>(context).filterLocation(_locationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unmastered Screen')
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _searchShit(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          onRefresh: () => _searchShit(context),
          child: Consumer<Contacts>(
            builder: (ctx, productsData, _) => Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    ShowState(
                      productsData.items[i].id,
                      productsData.items[i].fName,
                      productsData.items[i].lName,
                      productsData.items[i].state
                    ),
                    Divider()
                  ],
                ),
              ),
            ),
          )
        )
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmastered_server/solution/contacts/screen/one_to_many_message.dart';
import 'package:unmastered_server/solution/contacts/screen/unmastered_screen.dart';

import 'auth/auth.dart';
import 'auth/auth_screen.dart';
import 'auth/splash_screen.dart';
import 'solution/contacts/provider/contacts.dart';
import 'solution/contacts/screen/contact_detail_screen.dart';
import 'solution/contacts/screen/contacts_overview_screen.dart';
import 'solution/contacts/screen/create_new_contact.dart';
import 'solution/contacts/screen/sending_message_screen.dart';
import 'solution/contacts/screen/user_contacts_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Contacts>(
          builder: (ctx, auth, previousContacts) => Contacts(
            auth.token,
            auth.userId,
            previousContacts == null ? [] : previousContacts.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Unmastered_SARO',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.black,
            accentColor: Colors.green,
            fontFamily: 'Lato',
            scaffoldBackgroundColor: Colors.white,
            textSelectionHandleColor: Colors.green,
            textSelectionColor: Colors.greenAccent,
            cursorColor: Colors.green,
            toggleableActiveColor: Colors.green,
            inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.withOpacity(0.1)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: const TextStyle(
                color: Colors.green,
              ),
            ),
          ),
          home: auth.isAuth
              ? ContactOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ContactDetailScreen.routeName: (ctx) => ContactDetailScreen(),
            CreateNewContactForm.routeName: (ctx) => CreateNewContactForm(),
            UserContactsScreen.routeName: (ctx) => UserContactsScreen(),
            SendMessageScreen.routeName: (ctx) => SendMessageScreen(),
            UnmasteredScreen.routeName: (ctx) => UnmasteredScreen(),
            OneToManyMessage.routeName: (ctx) => OneToManyMessage()
          },
        ),
      ),
    );
  }
}

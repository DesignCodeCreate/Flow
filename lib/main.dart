import 'package:flow/models/flow_client.dart';
import 'package:flow/pages/login_page.dart';
import 'package:flow/pages/message_pages/home.dart';
import 'package:flow/themes/dark_mode.dart';
import 'package:flow/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlowClient client = FlowClient("Flow");

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? username = prefs.getString("username");
  final String? password = prefs.getString("password");
  final String? homeserver = prefs.getString("homeserver");

  if ([homeserver, username, password].every((value) => value != null)) {
    await client.checkHomeserver(Uri.https(homeserver!, ""));
    await client.login(
      LoginType.mLoginPassword,
      password: password,
      identifier: AuthenticationUserIdentifier(user: username!),
    );
  }
  runApp(MainApp(client: client));
}

class MainApp extends StatelessWidget {
  final FlowClient client;
  const MainApp({super.key, required this.client});

  Future<Widget> getPage() async {
    if (!client.isLogged()) {
      return LoginPage();
    } else {
      return Home(client: client);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      builder: (context, child) => Provider<FlowClient>(
        create: (context) => client,
        child: child,
      ),
      home: FutureBuilder(
          future: getPage(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return CircularProgressIndicator();
              case (ConnectionState.done):
                return snapshot.data ?? LoginPage();
              case (_):
                return LoginPage();
            }
          }),
    );
  }
}

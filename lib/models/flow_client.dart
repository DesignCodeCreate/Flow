import 'package:flow/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlowClient extends Client {
  Client? client;
  FlowClient(super.clientName, [this.client]);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return Function.apply(
      client.noSuchMethod,
      [invocation],
      invocation.namedArguments,
    );
  }

  Future<void> flowInit() async {
    client ??= Client(super.clientName);
    await client!.init();
  }

  Future<Client?> loginByPassword(
      String username, String password, String homeserver) async {
    try {
      await client?.checkHomeserver(Uri.https(homeserver));
      await client?.login(
        LoginType.mLoginPassword,
        password: password,
        identifier: AuthenticationUserIdentifier(user: username),
      );
      return client;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<Client?> loginByToken(String token) async {
    try {
      await client?.login(
        LoginType.mLoginToken,
        token: token,
      );
      return client;
    } catch (error) {
      throw Exception(error);
    }
  }
  

  logoutFlow(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    await client?.logout();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }
}

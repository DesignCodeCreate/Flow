import 'package:flow/models/flow_client.dart';
import 'package:flow/pages/message_pages/home.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController homeserverController =
        TextEditingController(text: "matrix.org");

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    bool _loading = false;

    late final client = Provider.of<FlowClient>(context, listen: false);

    void login() async {
      setState(() {
        _loading = true;
      });
      try {
        await client
            .checkHomeserver(Uri.https(homeserverController.text.trim(), ""));
        await client.login(
          LoginType.mLoginPassword,
          password: passwordController.text,
          identifier:
              AuthenticationUserIdentifier(user: usernameController.text),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('username', usernameController.text);
        prefs.setString('password', passwordController.text);
        prefs.setString('homeserver', homeserverController.text);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home(client: client)),
          (route) => false,
        );
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: homeserverController,
              readOnly: _loading,
              autocorrect: false,
              decoration: InputDecoration(
                prefixText: "https://",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                labelText: "Homeserver",
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 25.0),
            TextField(
              controller: usernameController,
              readOnly: _loading,
              autocorrect: false,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                labelText: "Username",
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              obscureText: true,
              controller: passwordController,
              readOnly: _loading,
              autocorrect: false,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                labelText: "Password",
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onPressed: _loading ? null : login,
                child: _loading
                    ? const LinearProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.login),
                        ],
                      ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}

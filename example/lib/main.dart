import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lwa/lwa.dart';

void main() {
  runApp(const MyApp());
}

// a very basic example of implementing LoginWithAmazon via flutter
// utilizes a stream to listen to login events from the amazon sdk over
// iOS and android
// https://developer.amazon.com/docs/login-with-amazon/documentation-overview.html
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _lwaPlugin = Lwa();
  bool isLoggedIn = false;
  Map user = {};

  @override
  void initState() {
    super.initState();
    // starts the authentication stream listener
    startStream();
  }

  // sign in to amazon
  Future<void> signIn() async {
    try {
      // pass an optional array of scopes
      // https://developer.amazon.com/docs/login-with-amazon/requesting-scopes-as-essential-voluntary.html
      // var scopes = ['profile', 'postal_code'];
      var scopes = ['profile'];
      await _lwaPlugin.signIn(scopes: scopes);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  // sign the user out from amazon
  // the access_token will no longer work
  Future<void> signOut() async {
    try {
      await _lwaPlugin.signOut();
      setState(() {
        isLoggedIn = false;
      });
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  // listen to the users' authentication state
  // loginSuccess event and values will return the users' profile & access token
  // logoutSuccess event will indicate the user has logged out
  startStream() {
    _lwaPlugin.getLWAAuthState().listen((event) {
      if(event.runtimeType == String) {
        event = jsonDecode(event);
      }
      switch(event["eventName"]) {
        case "loginSuccess":
          setState(() {
            isLoggedIn = true;
            user = {
              "user_id": event["user_id"],
              "name": event["name"],
              "email": event["email"],
              "accessToken": event["accessToken"]
            };
          });
          break;
        case "logoutSuccess":
          setState(() {
            isLoggedIn = false;
          });
          break;
        default:
          print(event);
      }
    });
  }

  TextStyle buttonTextStyle = const TextStyle(fontWeight: FontWeight.w800);
  EdgeInsets buttonPadding = const EdgeInsets.fromLTRB(48, 16, 48, 16);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: !isLoggedIn
              ? const Text('Login With Amazon')
              : Text("Welcome ${user['name']}"),
        ),
        body: Center(
            child: !isLoggedIn
                ? MaterialButton(
                    color: Colors.blueAccent,
                    padding: buttonPadding,
                    textColor: Colors.white,
                    onPressed: signIn,
                    child: Text("Sign In With Amazon", style: buttonTextStyle),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text(user['email'], style: buttonTextStyle),
                        Text(user['name'], style: buttonTextStyle),
                        MaterialButton(
                            color: Colors.amber,
                            padding: buttonPadding,
                            textColor: Colors.black,
                            onPressed: signOut,
                            child: Text("Sign Out From Amazon",
                                style: buttonTextStyle))
                      ])),
      ),
    );
  }
}

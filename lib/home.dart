import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'get_location.dart';
import 'listen_location.dart';
import 'permission_status.dart';
import 'service_enabled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart' as main;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Location location = Location();

  Future<void> _showInfoDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Tracker'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Created by Sristi Sonal'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    /// Method to Logout the `FirebaseUser` (`_firebaseUser`)
    try {
      // signout code
      await FirebaseAuth.instance.signOut();
      main.navigatorKey.currentState.pushReplacementNamed('/');
    } catch (e) {
      print("Error: " + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          PermissionStatusWidget(),
          ServiceEnabledWidget(),
          ListenLocationWidget(),
          SizedBox(height: 24),
          MaterialButton(
            onPressed: _logout,
            child: Text('Logout'),
            color: Theme.of(context).accentColor,
          )
        ],
      ),
    );
  }
}

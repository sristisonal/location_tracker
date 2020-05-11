import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map.dart';

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();

  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;
  String model;
  String androidId;
  List<LocationData> locationList = [];
  List<LatLng> latlng = [];

  @protected
  @mustCallSuper
  void initState() {
    _getDeviceInfo();
  }

  void _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    model = androidInfo.model;
    androidId = androidInfo.model;
    print('Running on ${androidInfo.model}, id: ${androidInfo.androidId}');
  }

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      setState(() {
        _error = err.code;
      });
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      setState(() {
        _error = null;
        _location = currentLocation;
        locationList.add(currentLocation);
        latlng.add(LatLng(currentLocation.latitude, currentLocation.longitude));
      });
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
    for (int i = 0; i < locationList.length; i++)
      print(
          "lat : ${locationList[i].latitude} lng: ${locationList[i].longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Listen location: ' + (_error ?? '${_location ?? "unknown"}'),
          style: Theme.of(context).textTheme.body2,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: RaisedButton(
                child: const Text('Listen'),
                onPressed: _listenLocation,
              ),
            ),
            RaisedButton(
              child: const Text('Stop'),
              onPressed: _stopListen,
            )
          ],
        ),
        Container(
          height: 300,
          color: Colors.amber[600],
          child: TestMapPolyline(latlng),
        ),
      ],
    );
  }
}
/*
Future<http.Response> send(double lat, double lng) {
  return http.post(
    'https://127.0.0.1:8080',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'lat': lat, 'lng': lng}),
  );
}
*/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestMapPolyline extends StatefulWidget {
  TestMapPolyline(List this.latlng, {Key key}) : super(key: key);

  List latlng;
  @override
  _TestMapPolylineState createState() => _TestMapPolylineState();
}

class _TestMapPolylineState extends State<TestMapPolyline> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  GoogleMapController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Map: I'm rebuilding");
    print(widget.latlng);
    if (widget.latlng.length < 1)
      return Text("Please enable 'Listen location'");

    return GoogleMap(
      //that needs a list<Polyline>
      polylines: _polyline,
      markers: _markers,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.latlng[0],
        zoom: 11.0,
      ),
      mapType: MapType.normal,
    );
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(widget.latlng[0].toString()),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: widget.latlng[0],
      ));

      // Only one entry is sufficient, clear rest
      _polyline.clear();
      _polyline.add(Polyline(
        geodesic: true,
        polylineId: PolylineId('my_path'),
        visible: true,
        //latlng is List<LatLng>
        points: widget.latlng,
        width: 2,
        color: Colors.blue,
      ));
    });
  }
}

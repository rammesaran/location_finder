import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position currentPosition;
  String currentAddress = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (currentPosition != null)
              Text(
                currentAddress,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text(
                "Get location",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                getCurrentLocation();
              },
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });

      getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> placeMarker = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = placeMarker[0];

      setState(() {
        currentAddress =
            " You are in : ${place.subLocality} Area , ${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}

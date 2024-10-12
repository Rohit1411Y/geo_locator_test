import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await _geolocatorPlatform.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      alertPopup(context);
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    alertPopup(context);
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  try {
    LocationSettings settings = const LocationSettings(
        accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 15));
    return await _geolocatorPlatform.getCurrentPosition(
        locationSettings: settings);
  } catch (_) {
    throw 'error';
  }
}

alertPopup(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content: Column(
            children: [
              Text('Location Permission Required'),
              ElevatedButton(
                  onPressed: () {
                    final GeolocatorPlatform _geolocatorPlatform =
                        GeolocatorPlatform.instance;
                    _geolocatorPlatform.openAppSettings();
                  },
                  child: Text('Open app settings'))
            ],
          ),
        );
      });
}

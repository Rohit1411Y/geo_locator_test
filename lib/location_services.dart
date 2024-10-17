// lib/location_service.dart

import 'dart:async';
import 'package:flutter/services.dart';

class LocationService {
  static const MethodChannel _channel =
      MethodChannel('com.yourcompany.location');

  /// Requests the current location from the native platform.
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      final Map<dynamic, dynamic> result =
          await _channel.invokeMethod('getCurrentLocation');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      throw 'Failed to get location: ${e.message}';
    }
  }

  /// Opens the app settings on the native platform.
  Future<void> openAppSettings() async {
    try {
      await _channel.invokeMethod('openAppSettings');
    } on PlatformException catch (e) {
      throw 'Failed to open app settings: ${e.message}';
    }
  }
}

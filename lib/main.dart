// // lib/main.dart

// import 'package:flutter/material.dart';
// import 'package:geo_locator_learning/location_services.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final LocationService _locationService = LocationService();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Method Channel Location Demo',
//       home: LocationPage(),
//     );
//   }
// }

// class LocationPage extends StatefulWidget {
//   @override
//   _LocationPageState createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   final LocationService _locationService = LocationService();
//   Map<String, dynamic>? _locationData;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchLocation();
//   }

//   Future<void> _fetchLocation() async {
//     try {
//       Map<String, dynamic> location =
//           await _locationService.getCurrentLocation();
//       setState(() {
//         _locationData = location;
//         _error = null;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//       });
//       if (e.toString().contains('permissions')) {
//         _showPermissionDialog();
//       } else {
//         _showErrorDialog();
//       }
//     }
//   }

// void _showPermissionDialog() {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text("Location Permission"),
//         content: Text("Location permission is required to use this feature."),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _locationService.openAppSettings();
//             },
//             child: Text("Open Settings"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _fetchLocation(); // Retry fetching location
//             },
//             child: Text("Retry"),
//           ),
//         ],
//       );
//     },
//   );
// }

//   void _showErrorDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Location Error"),
//           content: Text("An error occurred while fetching location."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _fetchLocation(); // Retry fetching location
//               },
//               child: Text("Retry"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildLocationInfo() {
//     if (_locationData == null) {
//       if (_error != null) {
//         return Text(
//           _error!,
//           style: TextStyle(color: Colors.red),
//           textAlign: TextAlign.center,
//         );
//       } else {
//         return CircularProgressIndicator();
//       }
//     } else {
//       return Text(
//         'Latitude: ${_locationData!["latitude"]}\nLongitude: ${_locationData!["longitude"]}',
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 18),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Method Channel Location"),
//       ),
//       body: Center(
//         child: _buildLocationInfo(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _fetchLocation,
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geo_locator_learning/location_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Method Channel Location Demo',
      home: LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationService _locationService = LocationService();
  Map<String, dynamic>? _locationData;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchLocation() async {
    try {
      Map<String, dynamic> location =
          await _locationService.getCurrentLocation();
      setState(() {
        _locationData = location;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (e.toString().contains('permissions')) {
        _showPermissionDialog();
      } else {
        _showErrorDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location Permission"),
          content: Text("Location permission is required to use this feature."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _locationService.openAppSettings();
              },
              child: Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchLocation(); // Retry fetching location
              },
              child: Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  // void _showPermissionDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Location Permission"),
  //         content: Text("Location permission is required to use this feature."),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _locationService.openAppSettings();
  //             },
  //             child: Text("Open Settings"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _fetchLocation(); // Retry fetching location
  //             },
  //             child: Text("Retry"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location Error"),
          content: Text("An error occurred while fetching location."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchLocation(); // Retry fetching location
              },
              child: Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  void _resetLocation() {
    setState(() {
      _locationData = null;
      _error = null;
    });
  }

  Widget _buildLocationInfo() {
    if (_locationData == null) {
      if (_error != null) {
        return Text(
          _error!,
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        );
      } else {
        return CircularProgressIndicator();
      }
    } else {
      return Text(
        'Latitude: ${_locationData!["latitude"]}\nLongitude: ${_locationData!["longitude"]}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Method Channel Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLocationInfo(),
            SizedBox(height: 20), // Add spacing between text and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _fetchLocation,
                  child: Text("Get Location"),
                ),
                ElevatedButton(
                  onPressed: _resetLocation,
                  child: Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geo_locator_learning/location_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double lat = 0.0;
  double lng = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GeoLocator Test'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Lat:$lat\nLng:$lng"),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              determinePosition(context).then((value) {
                print('value is $value');
                setState(() {
                  lat = value.latitude;
                  lng = value.longitude;
                });
              });
            },
            child: Text(" click to get location"),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              lat = 0.0;
              lng = 0.0;
              setState(() {});
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}

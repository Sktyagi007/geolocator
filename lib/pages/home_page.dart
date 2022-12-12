import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/location_page.dart';

List<String> numbers() {
  List<String> li = [];
  for (int i = 1; i <= 60; i++) {
    li.add(i.toString());
  }
  return li;
}

int splitMin(String value) {
  var arr = value.split(' ');
  int ans = int.parse(arr[0]);
  print(ans);
  return ans;
}

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myController = TextEditingController();
  // var min;
  // List minutes = numbers();
  String dropdownvalue = '1 min';
  var mac;
  int _minutes = 0;
  bool checkLocation = false;
  bool checkPermission = false;
  bool checkRequest = false;

  // List of items in our dropdown menu
  var items = [
    '1 min',
    '2 min',
    '3 min',
    '4 min',
    '5 min',
    '10 min',
    '15 min',
    '20 min',
    '30 min',
    '40 min',
    '50 min',
    '60 min',
  ];

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      setState(() {
        checkLocation = false;
      });
      return Future.error('Location services are disabled.');
    } else {
      setState(() {
        checkLocation = true;
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        setState(() {
          checkRequest = false;
        });
        return Future.error('Location permissions are denied');
      } else {
        setState(() {
          checkRequest = true;
        });
      }
      setState(() {
        checkPermission = false;
      });
    } else {
      setState(() {
        checkPermission = true;
      });
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("Geolocator"),
      ),
      body: Column(
        children: [
          SizedBox(height: 80),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter MAC Address',
              ),
            ),
          ),
          SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.all(0),
            child: Text(
              "Duration",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: DropdownButton(
              // Initial Value
              menuMaxHeight: 200,
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value

              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                  _minutes = splitMin(dropdownvalue);
                });
              },
            ),
          ),
          SizedBox(height: 80),
          SizedBox(
            width: 150.0,
            child: ElevatedButton(
              child: Text('Enable location'),
              onPressed: () {
                _determinePosition();
              },
            ),
          ),
          SizedBox(height: 80),
          SizedBox(
            width: 100.0,
            child: ElevatedButton(
              child: Text('Locate'),
              onPressed: (checkLocation && checkPermission && _minutes > 0)
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LocationPage(
                                minutes: _minutes,
                                MAC: myController.text,
                              )));
                    }
                  : null,
            ),
          )
        ],
      ),
    );
  }
}

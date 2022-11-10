import 'package:flutter_application_1/pages/sensor_page.dart';
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
  // print(ans);
  return ans;
}

class SecondHomePage extends StatefulWidget {
  // const SecondHomePage({Key? key}) : super(key: key);
  @override
  State<SecondHomePage> createState() => _SecondHomePageState();
}

class _SecondHomePageState extends State<SecondHomePage> {
  final myController = TextEditingController();
  // var min;
  // List minutes = numbers();
  String dropdownvalue = '1 min';
  var mac;
  int _minutes = 0;

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
        title: Text("Sensor Data"),
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
            width: 100.0,
            child: ElevatedButton(
              child: Text('start'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SensorPage(minutes: _minutes, MAC: myController.text)));
              },
            ),
          ),
          // SizedBox(height: 80),
          // SizedBox(
          //   width: 100.0,
          //   child: ElevatedButton(
          //     child: Text('locate'),
          //     onPressed: (checkLocation && checkPermission && _minutes > 0)
          //         ? () {
          //             Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (context) => SensorPage(
          //                       minutes: _minutes,
          //                       MAC: myController.text,
          //                     )));
          //           }
          //         : null,
          //   ),
          // )
        ],
      ),
    );
  }
}

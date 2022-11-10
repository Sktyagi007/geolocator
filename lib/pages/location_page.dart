import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

/// Determine the current position of the device.
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

class LocationPage extends StatefulWidget {
  // const LocationPage({Key? key}) : super(key: key);
  int minutes;
  var MAC;

  LocationPage({Key? key, required this.minutes, required this.MAC})
      : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<String> res = [];
  bool back = false;
  late String intValue;

  var resp;

 

  
  // List<dynamic> row = [];
  // String val = intValue.toString();

  @override
  void initState() {
    super.initState();
    print(widget.MAC);
    getPos(widget.minutes);
  }

  String getTimeStamp() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('jms');
    final String formatted = formatter.format(now);
    return formatted;
  }

  // List<dynamic> associateList = [];
  var uartFile = File('/storage/emulated/0/loc.txt');

  void getPos(minutes) {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position? position = await Geolocator.getCurrentPosition();
      String ans = position.toString();
      String timeS = getTimeStamp();
      String epoc = DateTime.now().millisecondsSinceEpoch.toString();
      res.add(ans);
      res.add(epoc);
      res.add(timeS);
      res.add("\n");
      // print(position);
      try {
        await File('/storage/emulated/0/loc.txt').writeAsString(
            ans + "," + epoc + "," + timeS + "\n",
            mode: FileMode.append);
        File('/storage/emulated/0/loc.txt')
            .readAsString()
            .then((String contents) {
          print(contents);
        });
      } catch (e) {
        print(e);
      }

      if (back) {
        timer.cancel();
      }
      if (mounted) {
        setState(() {
          resp = res.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("location"),
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            setState(() {
              back = true;
            });

            if (back == true) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Text(
              res.toString().length <= 0 ? "" : res.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

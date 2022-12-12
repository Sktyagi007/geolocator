import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


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
  List<dynamic> rows = [];
  List<List<dynamic>> objRows = [];
  List<dynamic> row = [];
  List<dynamic> row1 = [];
  File sf = File('/storage/emulated/0/loc.csv');
  Map<String, String> map = {};

  // List<dynamic> row = [];
  // String val = intValue.toString();

  @override
  void initState() {
    super.initState();
    initializeList();
    // print(widget.MAC);
    getPos(widget.MAC, widget.minutes);
  }

  void initializeList() {
    row.add("Lattitude");
    row.add("Longitude");
    row.add("Epoch-Time");
    row.add("TimeStamp");
    objRows.add(row);
  }

  void writeFile() async {
    String csv = ListToCsvConverter().convert(objRows);
    try {
      sf.writeAsString(csv);
      // File('/storage/emulated/0/loc.txt')
      //     .readAsString()
      //     .then((String contents) {
      //   print(contents);
      // });
    } catch (e) {
      print(e);
    }
  }

  String getTimeStamp() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('jms');
    final String formatted = formatter.format(now);
    return formatted;
  }


  postData(mac, lat, long, epoc, timeS) async {
    try {
      var data = jsonEncode([{
        "mac": mac.toString(),
        "Lattitude": lat.toString(),
        "Longitude": long.toString(),
        "Epoch_Time": epoc.toString(),
        "TimeStamp": timeS.toString(),
      }]);
      var response = await http.post(
          Uri.parse("http://app.napinotech.com:3000/app/v1/reference/stem"),
          headers: {
            "Content-Type": "application/json"
          },
          body: data);
    } catch (e) {
      print(e);
    }
  }
  // List<dynamic> associateList = [];
  // var uartFile = File('/storage/emulated/0/loc.txt');

  void getPos(MAC, minutes) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      Position? position = await Geolocator.getCurrentPosition();
      String ans = position.toString();
      String timeS = getTimeStamp();
      String epoc = DateTime.now().millisecondsSinceEpoch.toString();
      // res.add(epoc + " " + timeS + "-->" + ans);
      String lat = position.latitude.toString();
      String long = position.longitude.toString();
      map.putIfAbsent("mac", () => MAC);
      map.putIfAbsent("Lattitude", () => lat);
      map.putIfAbsent("Longitude", () => long);
      map.putIfAbsent("Epoch_Time", () => epoc);
      map.putIfAbsent("TimeStamp", () => timeS);
      String str = json.encode(map);
      row1.add(lat);
      row1.add(long);
      row1.add(epoc);
      row1.add(timeS);
      row1.add("\n");
      objRows.add(row1);
      rows.add(str);
      postData(MAC, lat, long, epoc, timeS);
      // print(rows);

      if (back) {
        timer.cancel();
      }
      if (mounted) {
        setState(() {
          resp = rows.toString();
          row1 = [];
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
            // writeFile();
            if (back == true) {
              writeFile();
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
              rows.toString().length <= 0 ? "" : rows.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';


/// Determine the current position of the device.
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.


class LocationPage extends StatefulWidget {
  // const LocationPage({Key? key}) : super(key: key);
  int minutes;
  var MAC;
  
  LocationPage({required this.minutes, required this.MAC});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<String> res = [];
  bool back = false;
  void initState() {
    print(widget.MAC);
    getPos(widget.minutes);
    super.initState();
  }

  void getPos(minutes) {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      Position? position = await Geolocator.getCurrentPosition();
      String ans = position.toString();
      res.add(ans);
      res.add(DateTime.now().millisecondsSinceEpoch.toString());
      res.add("\n");

      print(position);
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

  // void getLast() async {
  //   Position? position = await Geolocator.getLastKnownPosition();
  //   String ans = position.toString();
  //   res.add(ans);
  //   setState(() {
  //     resp = res.toString();
  //   });
  //   print(position);
  // }

  var resp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("location"),
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
      // floatingActionButton: FloatingActionButton(onPressed: getPos),
      // persistentFooterButtons: [
      //   ElevatedButton(onPressed: _determinePosition, child: Text("enabeLoc")),
      //   ElevatedButton(onPressed: getPos, child: Text("getPos"))
      // ],
    );
  }
}

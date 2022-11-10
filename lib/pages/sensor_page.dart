import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:io';

class SensorPage extends StatefulWidget {
  // const SensorPage({Key? key}) : super(key: key);
  int minutes;
  var MAC;

  SensorPage({Key? key, required this.minutes, required this.MAC})
      : super(key: key);

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  List<String> res = [];
  var resp;

  var aX;
  var aY;
  var aZ;
  var curraX;
  var curraY;
  var curraZ;

  var agX;
  var agY;
  var agZ;
  var curragX;
  var curragY;
  var curragZ;

  var gX;
  var gY;
  var gZ;
  var currgX;
  var currgY;
  var currgZ;

  var mX;
  var mY;
  var mZ;
  var currmX;
  var currmY;
  var currmZ;

  var back = false;
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<List<dynamic>> rows = [];
  List<dynamic> row = [];
  List<dynamic> row1 = [];
  File sf = File('/storage/emulated/0/sensor.csv');

  void initState() {
    // TODO: implement initState
    // startReadingSensors();

    initializeList();
    super.initState();
    readingAccel();

    readingGyro();

    readingAccelWith();

    readingMagneto();
    // timer();
  }

  void initializeList() {
    row.add("AccelerometerEvent - x");
    row.add("AccelerometerEvent - y");
    row.add("AccelerometerEvent - z");
    row.add("AccelerometerEvent(G) - x");
    row.add("AccelerometerEvent(G) - y");
    row.add("AccelerometerEvent(G) - z");
    row.add("GyroscopeEvent- x");
    row.add("GyroscopeEvent- y");
    row.add("GyroscopeEvent- z");
    row.add("MagnetometerEvent - x");
    row.add("MagnetometerEvent - y");
    row.add("MagnetometerEvent - z");
    rows.add(row);
  }

  // void timer() {
  // Timer.periodic(Duration(seconds: 5), (timer) async {
  void readingAccel() {
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          String x = event.x.toStringAsFixed(2);
          String y = event.y.toStringAsFixed(2);
          String z = event.z.toStringAsFixed(2);
          curraX = x;
          curraY = y;
          curraZ = z;
          row1.add(curraX);
          row1.add(curraY);
          row1.add(curraZ);

          // res.add(event.toString());
          setState(() {
            // _accelerometerValues = <double>[event.x, event.y, event.z];
            aX = curraX;
            aY = curraY;
            aZ = curraZ;
          });
          // dispose();
        },
      ),
    );
  }

  void readingAccelWith() {
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          String x = event.x.toStringAsFixed(2);
          String y = event.y.toStringAsFixed(2);
          String z = event.z.toStringAsFixed(2);
          curragX = x;
          curragY = y;
          curragZ = z;
          row1.add(curragX);
          row1.add(curragY);
          row1.add(curragZ);
          // res.add(event.toString());
          setState(() {
            // _accelerometerValues = <double>[event.x, event.y, event.z];
            agX = curragX;
            agY = curragY;
            agZ = curragZ;
          });
          // dispose();
        },
      ),
    );
  }

  void readingGyro() {
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          String x = event.x.toStringAsFixed(2);
          String y = event.y.toStringAsFixed(2);
          String z = event.z.toStringAsFixed(2);
          currgX = x;
          currgY = y;
          currgZ = z;
          row1.add(currgX);
          row1.add(currgY);
          row1.add(currgZ);

          // res.add(event.toString());
          setState(() {
            // _accelerometerValues = <double>[event.x, event.y, event.z];
            gX = currgX;
            gY = currgY;
            gZ = currgZ;
          });
          // dispose();
        },
      ),
    );
  }

  void readingMagneto() {
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          String x = event.x.toStringAsFixed(2);
          String y = event.y.toStringAsFixed(2);
          String z = event.z.toStringAsFixed(2);
          currmX = x;
          currmY = y;
          currmZ = z;
          row1.add(currmX);
          row1.add(currmY);
          row1.add(currmZ);
          rows.add(row1);

          // print(csv);
          setState(() {
            mX = currmX;
            mY = currmY;
            mZ = currmZ;
            row1 = [];
          });
        },
      ),
    );
  }

  void writeFile() async {
    String csv = ListToCsvConverter().convert(rows);
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

  void stop() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    return Scaffold(
      appBar: AppBar(
          title: Text("Sensor Data"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: () {
              stop();
              writeFile();
              setState(() {
                back = true;
              });
              Navigator.pop(context);
              // if (back) {
              //   Navigator.pop(context);
              // }
            },
          )),
      body: Padding(
        padding: EdgeInsets.all(7.5),
        child: ListView(
          children: [
            SizedBox(height: 25),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFDFE4EA),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(0, 0))
                  ]),
              height: 100,
              child: Center(
                child: ListTile(
                  title: Text(
                    "AccelerometerEvent\n"
                    "X:${aX} Y:${aY} Z:${aZ}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFDFE4EA),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(0, 0))
                  ]),
              height: 100,
              child: Center(
                child: ListTile(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => SensorPage()));
                  },
                  title: Text(
                    "AccelerometerEvent(G)\n"
                    "X:${agX} Y:${agY} Z:${agZ}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFDFE4EA),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(0, 0))
                  ]),
              height: 100,
              child: Center(
                child: ListTile(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => SensorPage()));
                  },
                  title: Text(
                    "GyroscopeEvent\n"
                    "X:${gX} Y:${gY} Z:${gZ}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFDFE4EA),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(0, 0))
                  ]),
              height: 100,
              child: Center(
                child: ListTile(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => SensorPage()));
                  },
                  title: Text(
                    "MagnetometerEvent\n"
                    "X:${mX} Y:${mY} Z:${mZ}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton:
      // FloatingActionButton(onPressed: startReadingSensors),
    );
  }
}

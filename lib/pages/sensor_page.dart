import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({Key? key}) : super(key: key);

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  List<String> res = [];
  var resp;

  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void initState() {
    // TODO: implement initState
    // startReadingSensors();
    reading();
    super.initState();
  }

  void reading() {
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  // void dispose() {
  //   super.dispose();
  //   for (final subscription in _streamSubscriptions) {
  //     subscription.cancel();
  //   }
  // }

  // void startReadingSensors() {
  //   try {
  //     Timer.periodic(Duration(seconds: 3), (timer) {
  //       accelerometerEvents.listen((AccelerometerEvent event) {
  //         print(event);

  //         res.add("accelerometer(With Gravity) --> " +
  //             "X - " +
  //             event.x.toString() +
  //             "Y - " +
  //             event.y.toString() +
  //             "Z - " +
  //             event.z.toString() +
  //             "\n");
  //       });
  // [AccelerometerEvent (x: 0.0, y: 9.8, z: 0.0)]

  // userAccelerometerEvents.listen((UserAccelerometerEvent event) {
  //   print(event);
  //   res.add("accelerometer(Without Gravity) --> " +
  //       "X - " +
  //       event.x.toString() +
  //       "Y - " +
  //       event.y.toString() +
  //       "Z - " +
  //       event.z.toString() +
  //       "\n");
  // });
  // // [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]

  // gyroscopeEvents.listen((GyroscopeEvent event) {
  //   print(event);
  //   res.add("Gyroscope --> " +
  //       "X - " +
  //       event.x.toString() +
  //       "Y - " +
  //       event.y.toString() +
  //       "Z - " +
  //       event.z.toString() +
  //       "\n");
  // });
  // // [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]

  // magnetometerEvents.listen((MagnetometerEvent event) {
  //   print(event);
  //   res.add("Magnetometer --> " +
  //       "X - " +
  //       event.x.toString() +
  //       "Y - " +
  //       event.y.toString() +
  //       "Z - " +
  //       event.z.toString() +
  //       "\n");
  // });
  //       setState(() {
  //         resp = res.toString();
  //       });
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Text(
              _accelerometerValues.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      // floatingActionButton:
      // FloatingActionButton(onPressed: startReadingSensors),
    );
  }
}

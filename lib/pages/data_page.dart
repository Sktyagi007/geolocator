import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/sensor_page.dart';
import 'package:flutter_application_1/utils/routes.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0085ba),
        automaticallyImplyLeading: false,
        title: Text('Sensor Data'),
      ),

      //the body contains 4 different cards for (uart,status,flash,full diagnostic)

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
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.search,
                      size: 40,
                      color: Color(0xFF0085ba),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  title: Text(
                    "Geolocator",
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
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.search,
                      size: 40,
                      color: Color(0xFF0085ba),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SensorPage()));
                  },
                  title: Text(
                    "Multi Sensor Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:naext/services/colors.dart';
import 'package:naext/views/trips/trips_view.dart';


class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return TripsView();
    return Scaffold(
      appBar: AppBar(
        title: Text("Naext Automotive", style: TextStyle(color: Colors.black, fontSize: 25),),
        backgroundColor: BACKGROUND_COLOR,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ListView(
            children: [
              Image.asset("assets/img/vw.png")
            ],
          ),
        ),
      )
    );
  }
}



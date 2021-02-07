import 'package:flutter/material.dart';
import 'package:naext/services/colors.dart';


class TripsView extends StatefulWidget {
  @override
  _TripsViewState createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: ListView(
              children: [
                SizedBox(height: 20,),
                Text("My Trips", style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                _tripsSummary(),
                SizedBox(height: 20,),
                _seperator(),
                SizedBox(height: 20,),
                _tripItem()
              ],
            ),
          ),
        )
    );
  }

  Widget _seperator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("January", style: TextStyle(color: Colors.black, fontSize: 25),),
          Row(
            children: [
              Text("6 Trips", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),),
              SizedBox(width: 20,),
              Text("9,1 km", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),),
              SizedBox(width: 20,),
              Text("102 min.", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),),
            ],
          )
        ],
      ),
    );
  }


  Widget _tripsSummary() {
    return Container(
      decoration: new BoxDecoration(
        color: FOREGROUND_COLOR,
        borderRadius: new BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: FOREGROUND_COLOR,
            offset: Offset(0.1, 2.0),
            blurRadius: 40.0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Column(
            children: [
              Text("19,5 km", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
              Text("Average Trip Distance", style: TextStyle(color: Colors.grey, fontSize: 12,),),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("19,5 km", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                  Text("Total Distance", style: TextStyle(color: Colors.grey, fontSize: 12),),
                ],
              ),
              Column(
                children: [
                  Text("24", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                  Text("total Rides", style: TextStyle(color: Colors.grey, fontSize: 12),),
                ],
              ),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("19,5 km", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                  Text("Total Distance", style: TextStyle(color: Colors.grey, fontSize: 12),),
                ],
              ),
              Column(
                children: [
                  Text("24", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                  Text("total Rides", style: TextStyle(color: Colors.grey, fontSize: 12),),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _tripItem() {
    return Container(
      decoration: new BoxDecoration(
        color: FOREGROUND_COLOR,
        borderRadius: new BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: FOREGROUND_COLOR,
            offset: Offset(0.1, 2.0),
            blurRadius: 40.0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 50,
            width: 150,
            color: Colors.white,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("27. Jan 2021", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
              Text("80 km", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
              Text("80 min.", style: TextStyle(color: Colors.white, fontSize: 12,),),
            ],
          ),
        ],
      ),
    );
  }
}

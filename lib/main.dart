/*
* Welcome to Wander!!
* */


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'dart:math';

var stop;
bool set = false;
double roundDouble(double value, int places){
  double mod = pow(10.0, places).toDouble();
  return ((value * mod).toInt() / mod);
}
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: new ThemeData(scaffoldBackgroundColor: const Color(000000000)),
      home: MyHomePage2(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin {

  LatLng _initialcameraposition = LatLng(17.41163, 17.41163);
  Location _location = Location();
  @override
  bool get wantKeepAlive => true;
  void _onMapCreated(GoogleMapController _cntlr)
  {
    GoogleMapController _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      print(roundDouble(l.latitude, 2));
      print(roundDouble(l.longitude, 2));
      print(roundDouble(stop.lat, 2));
      print(roundDouble(stop.lng, 2));
      if (roundDouble(l.latitude, 3) == roundDouble(stop.lat, 3)) {
        print("ZOMBIE");
        if (roundDouble(l.longitude, 3) == roundDouble(stop.lng, 3)) {
          print("DEADDD");
          if (!set) {
            print("ALIVE");
            // Create a timer for 42 seconds
            FlutterAlarmClock.createTimer(2);
            print('set!');
            set = true;
          }
        }
      }
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your current location'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [

            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition, zoom: 15),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
          ],
        ),
      ),
    );
  }


}

class MyHomePage2 extends StatelessWidget {
  void _fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...'),
                  Center(child: Text('Note: If map appears blank tap Recenter button at top right'))
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 4));

    // Close the dialog programmatically
    Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MyHomePage()));
  }
  @override
  Widget build (BuildContext ctxt) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(fontFamily: 'Gruppo', fontSize: 20, letterSpacing: 8.0,),
          title: Center(child: Text('Wander', style: TextStyle(fontFamily: 'Gruppo', fontSize: 18))),
        ),
        body: Center(child :Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

            Text('Hey', style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'League_Spartan'),),
            Text('Wanderer!', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'League_Spartan'),),
            Spacer(),
            Container(child: Image.network('https://i.ibb.co/RNVkj6v/bgbalfinal.png'),),


            Text('Set Alarms not just anytime', style: TextStyle(fontSize: 10, color: Colors.white),),
            Text('But also anywhere', style: TextStyle(fontFamily: 'Italianno', fontSize: 21, color: Colors.white),),

            const SizedBox(height: 10),
            ElevatedButton(
              style: style,
              onPressed:() => _fetchData(ctxt),
              child: const Text('Get Started', style: TextStyle(fontSize: 14, color: Colors.black)),
            ),

            Container(child: TextButton(
              child: Text('Select Stop'), onPressed: () {
              Navigator.of(ctxt).push(
                  MaterialPageRoute(builder: (context) => HomePage()));
            },
            )),
          ],
        ),
        )
    );
  }
}



class HomePage extends StatefulWidget {


  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  PickResult? selectedPlace;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(fontFamily: 'Gruppo', fontSize: 40, letterSpacing: 8.0,),
          title: Center(child: Text('Wander', style: TextStyle(fontFamily: 'Gruppo', fontSize: 18))),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network('https://thumbs.dreamstime.com/b/illustrations-cat-action-logo-black-background-animals-vector-isolated-cute-cat-icon-cat-logo-illustration-black-127910462.jpg'),
              ElevatedButton(
                child: Text("Load Map", style: TextStyle(color: Colors.black),),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: 'AIzaSyAK-4T1unDFsqv4LB_CL7NxY8Gl0cp2yBs',
                          initialPosition: HomePage.kInitialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,

                          //usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            selectedPlace = result;
                            print(result.formattedAddress);
                            print(result.geometry.location);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            stop = result.geometry.location;
                            set = false;
                            setState(() {});
                          },
                          //forceSearchOnZoomChanged: true,
                          //automaticallyImplyAppBarLeading: false,
                          //autocompleteLanguage: "ko",
                          //region: 'au',
                          //selectInitialPosition: true,
                          // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                          //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                          //   return isSearchBarFocused
                          //       ? Container()
                          //       : FloatingCard(
                          //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                          //           leftPosition: 0.0,
                          //           rightPosition: 0.0,
                          //           width: 500,
                          //           borderRadius: BorderRadius.circular(12.0),
                          //           child: state == SearchingState.Searching
                          //               ? Center(child: CircularProgressIndicator())
                          //               : RaisedButton(
                          //                   child: Text("Pick Here"),
                          //                   onPressed: () {
                          //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                          //                     //            this will override default 'Select here' Button.
                          //                     print("do something with [selectedPlace] data");
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                 ),
                          //         );
                          // },
                          // pinBuilder: (context, state) {
                          //   if (state == PinState.Idle) {
                          //     return Icon(Icons.favorite_border);
                          //   } else {
                          //     return Icon(Icons.favorite);
                          //   }
                          // },
                        );
                      },
                    ),
                  );
                },
              ),
              selectedPlace == null ? Container() : Text(selectedPlace!.formattedAddress ?? ""),
            ],
          ),
        ));
  }
}





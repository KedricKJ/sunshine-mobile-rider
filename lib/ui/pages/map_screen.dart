import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static final routeName = "map-screen";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(6.949405, 80.780125);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    return Scaffold(
      body: (currentPosition != null ) ? Column(
        children: <Widget>[
          Container(
            height:2.75*(MediaQuery.of(context).size.height/4),
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 16.0,
              ),
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
            ),
          ),
        ],
      ) : Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          )
      ),
    );
  }

}

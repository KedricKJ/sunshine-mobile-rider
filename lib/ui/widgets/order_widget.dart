import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sunshine_laundry_driver_app/models/mobile_order.dart';
import 'package:sunshine_laundry_driver_app/utils/colors.dart';
import 'package:sunshine_laundry_driver_app/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:sunshine_laundry_driver_app/utils/constants.dart';
import 'package:geolocator/geolocator.dart';

class OrderWidget extends StatefulWidget {
  final int pickup_order_ref;
  final String pickup_order_title;
  final String pickup_order_message;
  final String pickup_order_lat;
  final String pickup_order_lng;
  final String pickup_order_status;

  OrderWidget(
      this.pickup_order_ref,
      this.pickup_order_title,
      this.pickup_order_message,
      this.pickup_order_lat,
      this.pickup_order_lng,
      this.pickup_order_status);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {

  _buildOrderInfo(
    String title,
    String subtitle,
    int innerSubtitle,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.shoppingBag,
              size: 20,
              color: color,
            ),
          ],
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: CustomStyles.normalTextStyle),
            SizedBox(height: 3),
            Text(subtitle, style: CustomStyles.smallLightTextStyle),
            SizedBox(height: 3),
            Text("Reference : " + innerSubtitle.toString(), style: CustomStyles.smallLightTextStyle),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(RideDetailsPage.routeName);
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                  child: _buildOrderInfo(widget.pickup_order_title,
                      widget.pickup_order_message,widget.pickup_order_ref,Colors.green),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        _launchMapUrl(double.parse(widget.pickup_order_lat),
                            double.parse(widget.pickup_order_lng));
                      },
                      color: Color(ThemeColors.themePrimaryColor),
                      textColor: Colors.white,
                      child: Icon(
                        Icons.directions,
                        size: 15,
                      ),
                      padding: EdgeInsets.all(6),
                      shape: CircleBorder(),
                    ),
                    if (widget.pickup_order_status == Constants.orderStatusAvailableForAccept)
                      MaterialButton(
                        onPressed: () {
                          _showDialogForOperations(
                              widget.pickup_order_ref.toString(),
                              widget.pickup_order_title,
                              widget.pickup_order_message,
                              Constants.operationsAccept );
                        },
                        color: Color(ThemeColors.themePrimaryColor),
                        textColor: Colors.white,
                        child: Icon(
                          Icons.done_all,
                          size: 15,
                        ),
                        padding: EdgeInsets.all(6),
                        shape: CircleBorder(),
                      ),
                    if (widget.pickup_order_status == Constants.orderStatusAcceptedByRider)
                      MaterialButton(
                        onPressed: () {
                          _showDialogForOperations(
                              widget.pickup_order_ref.toString(),
                              widget.pickup_order_title,
                              "Do you want to start the order ?",
                              Constants.operationsStart);
                        },
                        color: Color(ThemeColors.themePrimaryColor),
                        textColor: Colors.white,
                        child: Icon(
                          Icons.arrow_right,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(6),
                        shape: CircleBorder(),
                      ),
                    if (widget.pickup_order_status == Constants.orderStatusOnGoing)
                      MaterialButton(
                        onPressed: () {
                          _showDialogForOperations(
                              widget.pickup_order_ref.toString(),
                              widget.pickup_order_title,
                              "Please verify, you picked up the package ?",
                              Constants.operationsCollected);
                        },
                        color: Color(ThemeColors.themePrimaryColor),
                        textColor: Colors.white,
                        child: Icon(
                          Icons.archive_sharp,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(6),
                        shape: CircleBorder(),
                      ),
                    if (widget.pickup_order_status == Constants.orderStatusCollectedByRider)
                      MaterialButton(
                        onPressed: () {
                          _showDialogForOperations(
                              widget.pickup_order_ref.toString(),
                              widget.pickup_order_title,
                              "You are going to handover the package",
                              Constants.operationsHandOver);
                        },
                        color: Color(ThemeColors.themePrimaryColor),
                        textColor: Colors.white,
                        child: Icon(
                          Icons.done_outline_sharp,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(6),
                        shape: CircleBorder(),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
        margin: EdgeInsets.only(left: 25, right: 25),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0x33303030),
              offset: Offset(0, 5),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
      ),
    );
  }

  _launchMapUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  _showDialogForOperations(String id,String title, String message,String operation) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: [
              TextButton(
                // onPressed: () => Navigator.pop(context, false), // passing false
                onPressed: () =>
                    {Navigator.of(context, rootNavigator: true).pop(false)},
                child: Text('Decline'),
              ),
              TextButton(
                // onPressed: () => Navigator.pop(context, true), // passing true
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(true),
                child: Text('Accept'),
              ),
            ],
          );
        }).then((accept) {
      if (accept == null) return;
      if (accept) {
        if(operation == Constants.operationsAccept){
          final FirebaseAuth auth = FirebaseAuth.instance;
          _updateItemForOperation(id,Constants.backendOrderStatusABR,{
            Constants.orderNotificationContainerAccepted: true,
            Constants.orderNotificationContainerOrderStatus: Constants.orderStatusAcceptedByRider,
            Constants.orderNotificationContainerAcceptedBy: auth.currentUser.uid,
          });
        }
        else if(operation == Constants.operationsStart){
          _updateItemForLocationUpdate();
          _updateItemForOperation(id,Constants.backendOrderStatusOG,{
            Constants.orderNotificationContainerOrderStatus: Constants.orderStatusOnGoing,
          });
        }
        else if(operation == Constants.operationsCollected){
          _updateItemForOperation(id,Constants.backendOrderStatusPCBR,{
            Constants.orderNotificationContainerOrderStatus: Constants.orderStatusCollectedByRider,
          });
        }
        else if(operation == Constants.operationsHandOver){
          _updateItemForOperation(id,Constants.backendOrderStatusHBR,{
            Constants.orderNotificationContainerAccepted: null,
            Constants.orderNotificationContainerOrderStatus: Constants.orderStatusHandoverByRider,
          });
        }
      } else {
        // user pressed No button
      }
    });
  }

  _updateItemForOperation(String orderId,String backendOrderStatus,var orderNotificationUpdatableData) async {

    String url = Constants.putMobileOrders;
    var putObject = {
      'mobileOrders': [
        {'id': orderId, 'status': backendOrderStatus}
      ]
    };

    var jsonPutObject = jsonEncode(putObject);

    await http.put(Uri.parse(url),
        body:jsonPutObject,
        headers: {"Content-Type": "application/json"}).then((result) {

      CollectionReference orderCollection =
          FirebaseFirestore.instance.collection(Constants.orderNotificationsContainer);
      orderCollection.doc(orderId).set(orderNotificationUpdatableData,SetOptions(merge: true));
    });
  }

  _updateItemForLocationUpdate() {
    Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high,distanceFilter: 1).listen((locationDetails) {
      CollectionReference riderLocationCollection =
      FirebaseFirestore.instance.collection(Constants.riderLocationsContainer);
      final FirebaseAuth auth = FirebaseAuth.instance;

      riderLocationCollection.doc(auth.currentUser.uid).set({
        Constants.riderCurrentLocationContainerCurrentLatitude: locationDetails.latitude.toString(),
        Constants.riderCurrentLocationContainerCurrentLongitude: locationDetails.longitude.toString(),
        Constants.riderCurrentLocationContainerLastUpdated: DateTime.now(),
      },SetOptions(merge: true));
    });
  }
}

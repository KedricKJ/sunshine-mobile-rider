import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunshine_laundry_driver_app/ui/widgets/header_widget.dart';
import 'package:sunshine_laundry_driver_app/ui/widgets/order_widget.dart';
import 'package:sunshine_laundry_driver_app/utils/constants.dart';
import 'package:sunshine_laundry_driver_app/utils/styles.dart';

class OrderHistoryScreen extends StatefulWidget {
  static final String routeName = "order-history-screen";
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();


}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  CollectionReference orderCollection =
  FirebaseFirestore.instance.collection(Constants.orderNotificationsContainer);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: mQ.width,
            height: mQ.height,
          ),
          NoLogoHeaderWidget(height: mQ.height * 0.5),
          Positioned(
              top: mQ.height * 0.05,
              child: Container(
                height: mQ.height,
                width: mQ.width,
                child: ListView(
                  children: <Widget>[
                    Text(
                      "Picked up orders",
                      textAlign: TextAlign.center,
                      style: CustomStyles.cardBoldTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
          ),
          StreamBuilder<QuerySnapshot>(
              stream: orderCollection.where(Constants.orderNotificationContainerAccepted,isEqualTo: null).where(Constants.orderNotificationContainerOrderStatus,isEqualTo: Constants.orderStatusHandoverByRider).where(Constants.orderNotificationContainerAcceptedBy,isEqualTo:auth.currentUser.uid).snapshots(),
              builder: (BuildContext context, snapshot) {
                if(snapshot.hasData){
                  return Positioned(
                      top: mQ.height * 0.18,
                      left: 5,
                      right: 5,
                      child: Container(
                        height: mQ.height * 0.8,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                            print(documentSnapshot.data());
                            print(documentSnapshot.id);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OrderWidget(documentSnapshot.get(Constants.orderNotificationContainerRefNumber),
                                  documentSnapshot.get(Constants.orderNotificationContainerTitle),
                                  "Contact : "+documentSnapshot.get(Constants.orderNotificationContainerMessage),
                                  documentSnapshot.get(Constants.orderNotificationContainerLatitude),
                                  documentSnapshot.get(Constants.orderNotificationContainerLongitude),Constants.orderStatusHandoverByRider),
                            );
                          },
                          itemCount: snapshot.data.docs.length,
                        ),
                      ));
                }
                else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
          ),
        ],
      ),
    );
  }

}


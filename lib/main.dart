import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/available_order_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/map_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/order_history_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/phone_login_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/dashboard_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/profile_screen.dart';
import 'package:sunshine_laundry_driver_app/utils/colors.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sunshine_laundry_driver_app/models/notification_message.dart';
import 'package:sunshine_laundry_driver_app/utils/constants.dart';
import 'package:http/http.dart' as http;

final _kShouldTestAsyncErrorOnInit = false;

final _kTestingCrashlytics = true;

Future<void> _messageHandler(RemoteMessage message) async {
  return await _AppState()._showNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runZonedGuarded(() {
    runApp(MaterialApp(home: App()));
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String firebaseDeviceToken = "Getting Firebase Token";

  Future<void> _initializeFlutterFireFuture;

  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _selectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) _AppState()._showNotification(message);
      Navigator.pushNamed(context, MapScreen.routeName,
          arguments: MessageArguments(message, true));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.pushNamed(context, MapScreen.routeName,
          arguments: MessageArguments(message, true));
    });

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFlutterFireFuture,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text("Could not load the app"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Sunshine Laundry',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Color(ThemeColors.themePrimaryColor),
            ),
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? PhoneLoginScreen.routeName
                : DashboardScreen.routeName,
            routes: {
              PhoneLoginScreen.routeName: (context) => PhoneLoginScreen(),
              DashboardScreen.routeName: (context) => DashboardScreen(),
              AvailableOrderScreen.routeName: (context) =>
                  AvailableOrderScreen(),
              OrderHistoryScreen.routeName: (context) => OrderHistoryScreen(),
              ProfileScreen.routeName: (context) => ProfileScreen(),
              MapScreen.routeName: (context) => MapScreen()
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            CircularProgressIndicator.adaptive(
              backgroundColor: Theme.of(context).primaryColor,
            )
          ],
        );
      },
    );
  }

  Future <void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    Map<String, dynamic> data = message.data;
    AndroidNotification android = message.notification?.android;

    NotificationMessage notificationMessage = NotificationMessage(
      id: data[Constants.orderNotificationContainerId],
      title: data[Constants.orderNotificationContainerTitle],
      message: data[Constants.orderNotificationContainerMessage],
      latitude: data[Constants.orderNotificationContainerLatitude],
      longitude: data[Constants.orderNotificationContainerLongitude],
    );
    String notificationJsonString = notificationMessage.toRawJson();

    if (data != null) {
      flutterLocalNotificationsPlugin.show(
        0,
        data[Constants.orderNotificationContainerTitle],
        data[Constants.orderNotificationContainerMessage],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            icon: android?.smallIcon,
            // other properties...
          ),
          iOS: IOSNotificationDetails(presentAlert: true, presentSound: true),
        ),
        payload: notificationJsonString,
      );
    }
  }

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    setState(() {
      firebaseDeviceToken = token;
    });
    final CollectionReference deviceTokenCollection =
        FirebaseFirestore.instance.collection(Constants.deviceTokenContainer);
    deviceTokenCollection
        .where(Constants.deviceTokenContainerToken, isEqualTo: firebaseDeviceToken)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        deviceTokenCollection.add({Constants.deviceTokenContainerToken: firebaseDeviceToken});
      }
    });
  }

  Future <void> _selectNotification(String payload) async {
    NotificationMessage notificationMessage =
        NotificationMessage.fromRawJson(payload);
    _showMaterialDialog(notificationMessage);
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  _showMaterialDialog(NotificationMessage notificationMessage) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(notificationMessage.title),
              content: new Text(notificationMessage.message),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Decline'),
                  child: const Text('Decline'),
                ),
                TextButton(
                  onPressed: () => _updateItem(notificationMessage.id),
                  child: const Text('Accept'),
                ),
              ],
            ));
  }

  _updateItem(String createdId) async {

    String url = Constants.putMobileOrders;
    final FirebaseAuth auth = FirebaseAuth.instance;

    var putObject = {
      "acceptedBy": auth.currentUser.phoneNumber,
      'mobileOrders': [
        {'id': createdId, 'status': Constants.backendOrderStatusABR}
      ]
    };

    var jsonPutObject = jsonEncode(putObject);

    await http.put(Uri.parse(url),
        body:jsonPutObject,
        headers: {"Content-Type": "application/json"}).then((result) {
      final FirebaseAuth auth = FirebaseAuth.instance;

      CollectionReference orderCollection =
      FirebaseFirestore.instance.collection(Constants.orderNotificationsContainer);

      orderCollection.doc(createdId).set({
        Constants.orderNotificationContainerAccepted: true,
        Constants.orderNotificationContainerOrderStatus: Constants.orderStatusAcceptedByRider,
        Constants.orderNotificationContainerAcceptedBy: auth.currentUser.uid
      },SetOptions(merge: true));
    });
  }
}

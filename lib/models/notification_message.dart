import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class NotificationMessage {
  String id;
  String title;
  String message;
  String latitude;
  String longitude;

  NotificationMessage({@required this.id,@required this.title, @required this.message, @required this.latitude, @required this.longitude});

  factory NotificationMessage.fromRawJson(String str) => NotificationMessage._fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(_toJson());

  factory NotificationMessage._fromJson(Map<String, dynamic> json) => NotificationMessage(
    id: json['id'],
    title: json['title'],
    message: json['message'],
    latitude: json['latitude'],
    longitude: json['longitude']
  );


  Map<String, dynamic> _toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class MessageArguments {
  /// The RemoteMessage
  final RemoteMessage message;

  /// Whether this message caused the application to open.
  final bool openedApplication;

  // ignore: public_member_api_docs
  MessageArguments(this.message, this.openedApplication)
      : assert(message != null);
}
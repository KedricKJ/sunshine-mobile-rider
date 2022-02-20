import 'dart:convert';
import 'package:meta/meta.dart';

class MobileOrder{
  String id;
  String status;

  MobileOrder({@required this.id,@required this.status});

  factory MobileOrder.fromRawJson(String str) => MobileOrder._fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(_toJson());

  factory MobileOrder._fromJson(Map<String, dynamic> json) => MobileOrder(
      id: json['id'],
      status: json['status'],
  );

  Map<String, dynamic> _toJson() => {
    'id': id,
    'status': status,
  };
}
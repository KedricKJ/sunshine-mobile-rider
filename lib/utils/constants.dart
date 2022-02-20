import 'package:flutter/material.dart';

class Constants{
  //Url
  static final String baseUrl ="http://52.212.29.143:10004/api/";

  //Update status
  static final String putMobileOrders = "${baseUrl}orders/status";

  //Constants
  static final String logo ="assets/images/laundry_logo.png";

  //Firebase Containers
  static final String deviceTokenContainer ="DeviceTokens";
  static final String orderNotificationsContainer ="OrderNotifications";
  static final String riderLocationsContainer ="RiderLocations";

  //Device token Container Node properties
  static final String deviceTokenUserPhoneNo ="phoneNo";
  static final String deviceTokenContainerToken ="token";

  //Order Container Node properties
  static final String orderNotificationContainerId ="id";
  static final String orderNotificationContainerRefNumber ="refNumber";
  static final String orderNotificationContainerAccepted ="accepted";
  static final String orderNotificationContainerLatitude ="latitude";
  static final String orderNotificationContainerLongitude ="longitude";
  static final String orderNotificationContainerMessage ="message";
  static final String orderNotificationContainerOrderStatus ="orderStatus";
  static final String orderNotificationContainerTitle ="title";
  static final String orderNotificationContainerAcceptedBy ="acceptedBy";

  //Rider location Container Node properties
  static final String riderCurrentLocationContainerCurrentLatitude ="currentLatitude";
  static final String riderCurrentLocationContainerCurrentLongitude ="currentLongitude";
  static final String riderCurrentLocationContainerLastUpdated ="lastUpdated";

  //Operations
  static final String operationsAccept ="accept";
  static final String operationsStart ="start";
  static final String operationsCollected ="collected";
  static final String operationsHandOver ="handOver";

  //Order Status
  static final String orderStatusAvailableForAccept ="AVAILABLE_FOR_ACCEPT";
  static final String orderStatusAcceptedByRider ="ACCEPTED_BY_RIDER";
  static final String orderStatusOnGoing ="ON_GOING";
  static final String orderStatusCollectedByRider ="COLLECTED_BY_RIDER";
  static final String orderStatusHandoverByRider ="HANDOVER_BY_RIDER";

  //BackEnd Order Status
  //Accepted By Rider
  static final String backendOrderStatusABR = "ABR";
  //On Going
  static final String backendOrderStatusOG = "OG";
  //Package Collected By Rider
  static final String backendOrderStatusPCBR = "PCBR";
  //Package Handover By Rider
  static final String backendOrderStatusHBR = "HBR";
}
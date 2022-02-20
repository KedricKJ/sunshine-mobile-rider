class Location{
  final double latitude;
  final double longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<dynamic,dynamic> parsedJson)
      :latitude = parsedJson["lat"],
      longitude = parsedJson["lng"];
}
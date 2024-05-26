import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContainerData {
  final String? key;
  final ContainerInfo? container;

  ContainerData({this.key, this.container});
}

class ContainerInfo {
  double? occupancyRate;
  double? temperature;
  int? sensorId;
  double? latitude;
  double? longitude;
  int? id;
  int? fullnessRate;
  String? nextCollectionDate;

  ContainerInfo({
    this.occupancyRate,
    this.temperature,
    this.sensorId,
    this.latitude,
    this.longitude,
    this.id,
    this.fullnessRate,
    this.nextCollectionDate,
  });

  ContainerInfo.fromJson(Map<dynamic, dynamic> json) {
    occupancyRate = json['occupancyRate'];
    temperature = json['temperature'];
    sensorId = json['sensorId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    id = json['id'];
    fullnessRate = json['fullnessRate'];
    nextCollectionDate = json['nextCollectionDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['occupancyRate'] = occupancyRate;
    data['temperature'] = temperature;
    data['sensorId'] = sensorId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['id'] = id;
    data['fullnessRate'] = fullnessRate;
    data['nextCollectionDate'] = nextCollectionDate;
    return data;
  }

  static List<ContainerInfo> listFromJson(List<dynamic>? json) {
    return json == null ? <ContainerInfo>[] : json.map((value) => ContainerInfo.fromJson(value)).toList();
  }

  LatLng get location => LatLng(latitude ?? -1, longitude ?? -1);
}

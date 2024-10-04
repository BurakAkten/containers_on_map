import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LocationExt on LatLng {
  double calculateDistance(LatLng loc) {
    const double R = 6371e3; // Earth r (m)
    final double lat1 = latitude * pi / 180;
    final double lat2 = loc.latitude * pi / 180;
    final double deltaLat = (loc.latitude - latitude) * pi / 180;
    final double deltaLon = (loc.longitude - longitude) * pi / 180;

    final double a = sin(deltaLat / 2) * sin(deltaLat / 2) + cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c / 1000; // distance (km)
  }
}

extension LocationListExtension on List<LatLng> {
  List<List<LatLng>> clusteredLocations(double distanceThreshold) {
    List<List<LatLng>> clusters = [];

    for (var loc in this) {
      bool foundCluster = false;
      for (var cluster in clusters) {
        if (loc.calculateDistance(cluster[0]) <= distanceThreshold) {
          cluster.add(loc);
          foundCluster = true;
          break;
        }
      }
      if (!foundCluster) clusters.add([loc]);
    }
    return clusters;
  }
}

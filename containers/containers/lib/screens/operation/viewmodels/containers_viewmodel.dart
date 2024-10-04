import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:containers/base/constants/app_constants.dart';
import 'package:containers/domain/dtos/container.dart';
import 'package:containers/utils/extensions/location_extension.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../utils/bitmap_util.dart';

class ContainersViewModel extends BaseViewModel {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child("containers");
  final int maxMarkerCountOnScreen = 50;
  final double defaultZoomLevel = 14, clusterZoomLevel = 13, maxZoomLevel = 4;
  double currentZoomLevel = 14;

  Completer<GoogleMapController> controller = Completer();
  final Set<Marker> _visibleMarkers = <Marker>{}, _allMarkers = <Marker>{}, _cluster = <Marker>{};

  List<ContainerInfo> _containers = [];
  ContainerInfo? _selectedContainer;
  bool isRelocating = false;
  Marker? newMarker;

  late BitmapDescriptor houseHoldMarker, batteryMarker;

  @override
  FutureOr<void> init() async {
    houseHoldMarker = await BitmapUtil.bitmapDescriptorFromSvgAsset("assets/images/household_marker.svg");
    batteryMarker = await BitmapUtil.bitmapDescriptorFromSvgAsset("assets/images/battery_marker.svg");

    _databaseReference.onValue.listen((data) async {
      _allMarkers.clear();
      _containers = ContainerInfo.listFromJson(data.snapshot.value as List);
      for (int i = 0; i < _containers.length; i++) {
        var item = _containers[i];
        final Marker marker = Marker(
          consumeTapEvents: true,
          markerId: MarkerId("${item.id}"),
          position: item.location,
          icon: houseHoldMarker,
          onTap: () => markerOnTap(item),
        );
        _allMarkers.add(marker);
      }
      onCameraPositionChange();
      reloadState();
    });
  }

  void markerOnTap(item) {
    selectedContainer = item;

    var preSelected = _visibleMarkers.firstWhereOrNull((m) => m.markerId.value.contains("selected"));
    var selected = _visibleMarkers.firstWhereOrNull((m) => m.markerId.value == "${item?.id}");

    if (preSelected != null) {
      _visibleMarkers.removeWhere((m) => m.markerId.value.contains("selected"));
      final Marker marker = Marker(
        consumeTapEvents: true,
        position: preSelected.position,
        icon: houseHoldMarker,
        markerId: MarkerId(preSelected.markerId.value.replaceAll("selected", "")),
        onTap: preSelected.onTap,
      );
      _visibleMarkers.add(marker);
    }

    if (selected != null) {
      _visibleMarkers.removeWhere((m) => m.markerId.value == "${item.id}");
      final Marker marker = Marker(
        consumeTapEvents: true,
        position: selected.position,
        icon: batteryMarker,
        markerId: MarkerId("selected${selected.markerId.value}"),
        onTap: selected.onTap,
      );
      _visibleMarkers.add(marker);
    }

    reloadState();
  }

  FutureOr<void> onCameraPositionChange() async {
    var controllerValue = await controller.future;
    var zoomLevel = await controllerValue.getZoomLevel();
    if (zoomLevel < clusterZoomLevel) {
      currentZoomLevel = zoomLevel;
      await _setClusters(controllerValue, zoomLevel);
      await _setVisibleMarkers(_cluster, controllerValue);
    } else if (_allMarkers.length >= maxMarkerCountOnScreen) {
      await _setVisibleMarkers(_allMarkers, controllerValue);
    } else {
      for (var element in _allMarkers) {
        _visibleMarkers.add(element);
      }
    }
    if (selectedContainer != null) {
      markerOnTap(selectedContainer);
    }
    reloadState();
  }

  Future<void> _setClusters(GoogleMapController controllerValue, double zoomLevel) async {
    _cluster.clear();
    if (zoomLevel <= maxZoomLevel) {
      var latitude = (_allMarkers.map((e) => e.position.latitude).reduce((value, element) => value + element) / _allMarkers.length);
      var longitude = (_allMarkers.map((e) => e.position.longitude).reduce((value, element) => value + element) / _allMarkers.length);
      final Marker marker = Marker(
        markerId: const MarkerId("all"),
        position: LatLng(latitude, longitude),
        icon: await BitmapUtil.getClusterMarkerCanvas(_allMarkers.length, AppColors.green),
      );
      _cluster.add(marker);
      return;
    }

    var visibleRegion = await controllerValue.getVisibleRegion();
    var filteredMarkers = _allMarkers.where((element) => visibleRegion.contains(element.position)).toList();
    var clusters = (filteredMarkers.map((c) => c.position).toList()).clusteredLocations(6);
    for (int i = 0; i < clusters.length; i++) {
      Color markerColor = Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));
      var cluster = clusters[i];
      var latitude = (cluster.map((e) => e.latitude).reduce((value, element) => value + element) / cluster.length);
      var longitude = (cluster.map((e) => e.longitude).reduce((value, element) => value + element) / cluster.length);
      final Marker marker = Marker(
        markerId: MarkerId(cluster.toString()),
        position: LatLng(latitude, longitude),
        icon: await BitmapUtil.getClusterMarkerCanvas(cluster.length, markerColor),
      );
      _cluster.add(marker);
    }
  }

  Future<void> _setVisibleMarkers(Set<Marker> markers, GoogleMapController controller) async {
    var visibleRegion = await controller.getVisibleRegion();
    var filteredMarkers = markers.where((element) => visibleRegion.contains(element.position)).toList();
    if (filteredMarkers.length >= maxMarkerCountOnScreen) filteredMarkers = filteredMarkers.getRange(0, maxMarkerCountOnScreen).toList();
    _visibleMarkers.clear();
    for (var element in filteredMarkers) {
      _visibleMarkers.add(element);
    }
  }

  Future<void> navigateToSelected() async {
    (await controller.future).animateCamera(CameraUpdate.newLatLng(selectedContainer!.location));
  }

  Future<void> relocateSelected() async {
    isRelocating = true;
    reloadState();
  }

  Future<void> changeSelectedContainerLocation() async {
    var selectedIndex = _containers.indexWhere((c) => c.id == selectedContainer!.id);

    var container = selectedContainer!
      ..latitude = newMarker!.position.latitude
      ..longitude = newMarker!.position.longitude;

    isLoading = true;
    await _databaseReference.child("$selectedIndex").update(container.toJson());
    isLoading = false;

    (await controller.future).animateCamera(CameraUpdate.newLatLng(newMarker!.position));

    isRelocating = false;
    selectedContainer = null;
    newMarker = null;
    reloadState();
  }

  FutureOr<void> onMapTap(LatLng newLocation) async {
    if (isRelocating) {
      newMarker = Marker(
        consumeTapEvents: true,
        markerId: MarkerId("${selectedContainer!.id}-New"),
        position: newLocation,
        icon: houseHoldMarker,
        onTap: () {},
      );
      reloadState();
    } else {
      isRelocating = false;
      selectedContainer = null;
      newMarker = null;
      markerOnTap(null);
      reloadState();
    }
  }

  //Setters
  set selectedContainer(ContainerInfo? value) {
    _selectedContainer = value;
    reloadState();
  }

  //Getters
  LatLng get initialPosition => _visibleMarkers.isNotEmpty ? _visibleMarkers.first.position : const LatLng(41.0165, 29.1247);
  ContainerInfo? get selectedContainer => _selectedContainer;
  Set<Marker> get routeMarkers => newMarker != null
      ? {newMarker!, _visibleMarkers.firstWhere((marker) => marker.markerId.value.contains(selectedContainer!.id!.toString()))}
      : isRelocating
          ? _visibleMarkers.where((marker) => marker.markerId.value.contains(selectedContainer!.id!.toString())).toSet()
          : _visibleMarkers;
}

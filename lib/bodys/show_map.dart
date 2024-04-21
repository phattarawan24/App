import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oilproj/controllers/map_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({super.key});
  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  MapController mapController = Get.put(MapController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController.fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Obx(
        () => mapController.mapModel.isNotEmpty
            ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(mapController.mapModel.first.lat),
                      double.parse(mapController.mapModel.first.lng)),
                  zoom: 13,
                ),
                markers: mapController.markers,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      )),
    );
  }
}

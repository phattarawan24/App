import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oilproj/utility/app_controller.dart';
import 'package:oilproj/utility/app_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({super.key});

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  final formKey = GlobalKey<FormState>();
  AppController appController = Get.put(AppController());

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePlex = LatLng(37.3346, -122.0090);

  @override
  Widget build(BuildContext context) {
    AppService().readAllTreeDatabase();
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pGooglePlex,
          zoom: 13,
        ),
        markers:{
          Marker(
            markerId: MarkerId("1"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex,
            infoWindow: InfoWindow(title: 'GooglePlex'),),
          Marker(
            markerId: MarkerId("2"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pApplePlex,
            infoWindow: InfoWindow(title: 'ApplePlex'),)
        },
      ),
    );
    
  }
}

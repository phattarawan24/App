import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:oilproj/states/showdetail.dart';
import 'package:oilproj/models/map_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapController extends GetxController {
  List<MapModel> mapModel = <MapModel>[].obs;
  var markers = RxSet<Marker>();
  var isLoading = false.obs;

  fetchLocations() async {
    try {
      isLoading(true);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userID = preferences.getString('id').toString();

      http.Response response = await http.get(Uri.tryParse(
          'http://172.20.10.4:8080/api/getTreeWhereUser.php?userID=${userID}')!);
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        log(result.toString());
        mapModel.addAll(RxList<Map<String, dynamic>>.from(result)
            .map((e) => MapModel.fromJson(e))
            .toList());
      } else {
        print('error fetching data');
      }
    } catch (e) {
      print('Error while getting data is $e');
    } finally {
      isLoading(false);
      print('finaly: $mapModel');
      createMarkers();
    }
  }

  createMarkers() {
    double coloricon = 240.0;
    mapModel.forEach((element) {
      markers.add(Marker(
        markerId: MarkerId(element.id.toString()),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            double.parse(element.coloricon)),
        position: LatLng(double.parse(element.lat), double.parse(element.lng)),
        infoWindow: InfoWindow(title: element.name, snippet: element.nameTree),
        onTap: () {
          print(element.id.toString());
          Get.to(
            () => ShowDetail(),
            arguments: {
              "urlImage": element.urlImage,
              "lat": element.lat,
              "lng": element.lng,
              "name": element.name,
              "nameTree": element.nameTree,
              "height": element.height,
            },
          );
        },
      ));
    });
  }
}

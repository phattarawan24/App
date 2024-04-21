import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:oilproj/widgets/widget_form.dart';
import 'package:oilproj/widgets/widget_text.dart';

class ShowDetail extends StatefulWidget {
  const ShowDetail({super.key});
  @override
  State<ShowDetail> createState() => _ShowDetailState();
}

class _ShowDetailState extends State<ShowDetail> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
    final String imageUrl =
        'http://172.20.10.4:8080/api/${args['urlImage']}'; // Replace with your image URL
    final String name = '${args['nameTree']}';
    final String lat = 'lat = ${args['lat']}';
    final String lng = 'lng = ${args['lng']}';
    final String height = 'height = ${args['height']}';

    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(data: 'Detail Tree'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Image.network(
                          imageUrl,
                          width: 200.0, // Adjust the width as needed
                          height: 200.0, // Adjust the height as needed
                          fit: BoxFit.cover, // Adjust the BoxFit as needed
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          lat,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          lng,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          height,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: Center(
    //     child: Image.network(
    //       imageUrl,
    //       width: 200.0, // Adjust the width as needed
    //       height: 200.0, // Adjust the height as needed
    //       fit: BoxFit.cover, // Adjust the BoxFit as needed
    //     ),

    //   ),
    // );
  }
}

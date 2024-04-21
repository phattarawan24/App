import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilproj/bodys/show_map.dart';
import 'package:oilproj/utility/app_constant.dart';
import 'package:oilproj/utility/app_controller.dart';
import 'package:oilproj/widgets/widget_button.dart';
import 'package:oilproj/widgets/widget_form.dart';
import 'package:oilproj/widgets/widget_icon_button.dart';
import 'package:oilproj/widgets/widget_image.dart';
import 'package:oilproj/widgets/widget_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class AddTree extends StatefulWidget {
  const AddTree({super.key});

  @override
  State<AddTree> createState() => _AddTreeState();
}

class _AddTreeState extends State<AddTree> {
  AppController appController = Get.put(AppController());
  TextEditingController treeNameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String? idTree;
  File? file;
  String idUser = "";
  Position? userLocation;
  bool isFormVisible = false;

  String dropdownvalue = 'Red';
  var items = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Purple',
  ];

  @override
  void initState() {
    super.initState();
    findUser();
    _getLocation();
  }

  Future<Position> _getLocation() async {
    return userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString('id').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        displayImage(),
        cameraButton(),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // padding: const EdgeInsets.symmetric(horizontal: 16),
                // decoration: AppConstant().borderBox(),
                width: 250,
                child: DropdownButton(
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const WidgetText(data: 'Please Choose Name'),
                  value: appController.chooseDatabaseModels.last,
                  items: appController.databaseModels
                      .map(
                        (element) => DropdownMenuItem(
                          child: WidgetText(data: element.name),
                          value: element,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    idTree = value!.id;
                    appController.chooseDatabaseModels.add(value);

                    setState(() {
                      if (idTree == '0') {
                        isFormVisible = true;
                      } else {
                        isFormVisible = false;
                      }
                    });
                  },
                ),
              ),
            ],
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: Form(
                child: Column(
                  children: [
                    Visibility(
                      visible: isFormVisible,
                      child: DropdownButton(
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: const WidgetText(data: 'Please Choose Color'),
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: isFormVisible,
                      child: WidgetForm(
                        textEditingController: treeNameController,
                        labelWidget: const WidgetText(data: 'Tree Name'),
                        validateFunc: (p0) {
                          if (p0?.isEmpty ?? true) {
                            return 'Please Fill Tree Name';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    WidgetForm(
                      textEditingController: heightController,
                      labelWidget: const WidgetText(data: 'Height'),
                      validateFunc: (p0) {
                        if (p0?.isEmpty ?? true) {
                          return 'Please Fill Height';
                        } else {
                          return null;
                        }
                      },
                    ),
                    WidgetButton(
                      data: 'Add Tree',
                      pressFunc: () async {
                        var uri = Uri.parse(
                            "http://172.20.10.4:8080/api/insertTree.php");
                        String imageName = '${Random().nextInt(1000000)}.jpg';

                        if (file != null) {
                          var stream = new http.ByteStream(file!.openRead());
                          stream.cast();

                          double? lat = userLocation?.latitude;
                          double? lng = userLocation?.longitude;

                          var request = http.MultipartRequest("POST", uri);
                          request.fields['idRec'] = idUser.toString();
                          request.fields['idTree'] = idTree.toString();
                          request.fields['color'] = dropdownvalue.toString();
                          request.fields['nameTree'] = treeNameController.text;
                          request.fields['height'] = heightController.text;
                          request.fields['lat'] = lat.toString();
                          request.fields['lng'] = lng.toString();
                          request.fields['imageName'] = imageName;

                          var pic = await http.MultipartFile.fromPath(
                              "image", file!.path);
                          request.files.add(pic);
                          var response = await request.send();
                          if (response.statusCode == 200) {
                            // print("image uploaded");
                            Get.snackbar('Add Tree', 'Save Tree Success');
                            // Get.to(() => ShowMap());
                            setState(() {
                              dropdownvalue = 'Red';
                            });
                            treeNameController.clear();
                            heightController.clear();
                          } else {
                            // print("uploaded faild");
                            Get.snackbar('Add Tree False', 'Please Try Again');
                          }
                        } else {
                          Get.snackbar('Add Tree', 'Please Choose Image');
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row cameraButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              WidgetIconButton(
                iconData: Icons.add_a_photo,
                pressFunc: () {
                  chooseImage();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future chooseImage() async {
    try {
      final returnedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxWidth: 800, maxHeight: 800);
      if (returnedImage == null) return;
      setState(() {
        file = File(returnedImage.path);
        File file1 = File(returnedImage.path);
        appController.files.add(file1);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget displayImage() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: AppConstant().borderBox(),
            child: appController.files.isEmpty
                ? const WidgetImage(
                    size: 250,
                  )
                : Image.file(
                    appController.files.last,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      );
    });
  }
}

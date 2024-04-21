import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oilproj/widgets/widget_button.dart';
import 'package:oilproj/widgets/widget_form.dart';
import 'package:oilproj/widgets/widget_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  String nameUser = "";
  String idUser = "";

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString('id').toString();
      nameUser = preferences.getString('name').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Column(
                      children: [
                        WidgetForm(
                          textEditingController: nameController,
                          labelWidget: WidgetText(data: 'Name: $nameUser'),
                          validateFunc: (p0) {
                            if (p0?.isEmpty ?? true) {
                              return 'Please Fill Name';
                            } else {
                              return null;
                            }
                          },
                        ),
                        WidgetButton(
                          data: 'Edit Profile',
                          pressFunc: () async {
                            String urlInsertUser =
                                'http://172.20.10.4:8080/api/editProfile.php?id=${idUser.toString()}&name=${nameController.text}';
                            await Dio().get(urlInsertUser).then((value) {
                              Get.back();
                              Get.snackbar(
                                  'Edit Account Success', 'Save Name Success');
                            });
                          },
                        ),
                        WidgetButton(
                          data: 'Sign Out',
                          pressFunc: () async {
                            await GetStorage()
                                .erase()
                                .then((value) => Get.offAllNamed('/authen'));
                          },
                        )
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
  }
}

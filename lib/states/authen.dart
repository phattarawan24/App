import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilproj/models/user_model.dart';
import 'package:oilproj/states/create_account.dart';
import 'package:oilproj/states/main_home.dart';
import 'package:oilproj/utility/app_constant.dart';
import 'package:oilproj/widgets/widget_button.dart';
import 'package:oilproj/widgets/widget_form.dart';
import 'package:oilproj/widgets/widget_image.dart';
import 'package:oilproj/widgets/widget_text.dart';
import 'package:oilproj/widgets/widget_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
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
                          const SizedBox(height: 100),
                          displayHead(),
                          WidgetForm(
                            validateFunc: (p0) {
                              if (p0?.isEmpty ?? true) {
                                return 'กรุณากรอก User ด้วย';
                              } else {
                                return null;
                              }
                            },
                            textEditingController: userController,
                            hint: 'User :',
                            suffigWidget: const Icon(Icons.perm_identity),
                          ),
                          WidgetForm(
                            validateFunc: (p0) {
                              if (p0?.isEmpty ?? true) {
                                return 'กรุณากรอก Password';
                              } else {
                                return null;
                              }
                            },
                            textEditingController: passwordController,
                            hint: 'Password :',
                            suffigWidget: const Icon(Icons.lock_outline),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 250,
                            child: WidgetButton(
                              data: 'Login',
                              pressFunc: () async {
                                if (formKey.currentState!.validate()) {
                                  String urlApi =
                                      "http://172.20.10.4:8080/api/getUserWhereUser.php?isAdd=true&user=${userController.text}";

                                  await Dio().get(urlApi).then((value) async {
                                    if (value.toString() == 'null') {
                                      Get.snackbar('User False',
                                          'ไม่มี User นี่ใน ฐานข้อมูล');
                                    } else {
                                      for (var element
                                          in json.decode(value.data)) {
                                        UserModel userModel =
                                            UserModel.fromMap(element);
                                        if (passwordController.text ==
                                            userModel.password) {
                                          //Login Success
                                          SharedPreferences sharedPreferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          sharedPreferences.setString(
                                              'id', userModel.id);
                                          sharedPreferences.setString(
                                              'name', userModel.name);

                                          Get.snackbar('Login Success',
                                              'Welcome to My App');
                                          Get.offAll(const MainHome());
                                          // Get.offAll(const MainHome(), arguments: [
                                          //     {"id": userModel.id},
                                          //     {"name": userModel.name}
                                          // ]);
                                        } else {
                                          Get.snackbar('Password False',
                                              'Please Try Again Password False');
                                        }
                                      }
                                    }
                                  });
                                }
                              },
                            ),
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
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetTextButton(
            data: 'Create New Account',
            pressFunc: () {
              Get.to(const CreateAccount());
            },
          ),
        ],
      ),
    );
  }

  Row displayHead() {
    return Row(
      children: [
        const WidgetImage(
          size: 100,
        ),
        WidgetText(
          data: 'WU Tree',
          textStyle: AppConstant().h2Style(),
        )
      ],
    );
  }
}

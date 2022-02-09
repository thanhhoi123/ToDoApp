import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:init_project/app/modules/home/views/profile_user_screen.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 3 * width/4,
              child: ElevatedButton(
                onPressed: () async {
                  await controller.googleLogin();
                  Get.to(() => ProfileUserScreen());
                }, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                    SizedBox(width: 8,),
                    Text('Sign in with google', style: TextStyle(fontSize: 16),)
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

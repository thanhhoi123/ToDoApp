import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:init_project/app/modules/home/controllers/home_controller.dart';
import 'package:init_project/app/modules/home/views/home_view.dart';

class ProfileUserScreen extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async{
              await controller.googleLogout();
              Get.to(() => HomeView());
            }, 
            icon: Icon(Icons.logout)
            )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(controller.user!.photoUrl.toString()),
            ),
            SizedBox(height: 8,),
            Text('Name: ${controller.user!.displayName}'),
            SizedBox(height: 8,),
            Text('Email: ${controller.user!.email}'),
          ],
        ),
      ),
    );
  }
  
}
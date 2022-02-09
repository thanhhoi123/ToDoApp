import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:init_project/app/modules/home/controllers/home_controller.dart';

class CreateTodoScreen extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Title'
              ),
              onSubmitted: (value) {
                controller.titleCreate = value;
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Content'
              ),
              onSubmitted: (value){
                controller.contentCreate = value;
              },
            ),
            SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () async {
                await controller.createTodo(controller.titleCreate.toString(), controller.contentCreate.toString());
                Get.back();
              }, 
              child: Text('Submit')
            ),
          ],
        ),
      ),
    );
  }

}
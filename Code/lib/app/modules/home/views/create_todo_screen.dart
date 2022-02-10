import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:init_project/app/modules/home/controllers/home_controller.dart';
import 'package:intl/intl.dart';

class CreateTodoScreen extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
        centerTitle: true,
      ),
      body: Container(
        height: height /2,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: height/8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8,),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(8)
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Title'
                ),
                onChanged: (value) {
                  controller.titleCreate = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(8)
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Content'
                ),
                maxLines: 4,
                onChanged: (value){
                  controller.contentCreate = value;
                },
              ),
            ),
            Obx((){
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: ListTile(
                  title: Text('${controller.datetimeText.value}'),
                  trailing: IconButton(
                    icon: Icon(Icons.access_alarms, size: 30,),
                    onPressed: () => pickDateTime(context)
                  ),
                ),
              );
            }),
            SizedBox(height: 50,),
            ElevatedButton(
              onPressed: () async {
                await controller.createTodo(
                  controller.titleCreate.toString(), 
                  controller.contentCreate.toString(),
                  controller.datetimePicker.toString()
                );
                Get.back();
              }, 
              child: Text('Submit')
            ),
          ],
        ),
      ),
    );
  }
  Future<void> pickDateTime(BuildContext context) async{    
    try{
      final date = await showDatePicker(
        context: context, 
        initialDate: controller.datetimePicker ?? controller.initDate, 
        firstDate: DateTime(DateTime.now().year - 5), 
        lastDate: DateTime(DateTime.now().year + 5)
      );

      final time = await showTimePicker(
        context: context, 
        initialTime: controller.datetimePicker != null
          ? TimeOfDay(hour: controller.datetimePicker!.hour, minute: controller.datetimePicker!.minute)
          : controller.initTime
      );

      controller.datetimePicker = DateTime(
        date!.year,
        date.month,
        date.day,
        time!.hour,
        time.minute
      );

      controller.datetimeText.value = DateFormat('dd/MM/yyyy HH:mm').format(controller.datetimePicker!).toString();
      }
    catch(e){
      print(e);
    }
  } 
}
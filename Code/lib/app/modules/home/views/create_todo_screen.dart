import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:init_project/app/modules/home/controllers/home_controller.dart';
import 'package:intl/intl.dart';

class CreateTodoScreen extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        title: const Text('Create Todo'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            controller.datetimeText.value = 'Due date';
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height /2,
          decoration: BoxDecoration(
            color: Colors.amber[50],
            border: Border.all(color: Colors.black, width: 3)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: height/8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8,),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: TextFormField(
                  initialValue: controller.isUpdate ? '${controller.todoUpdateOrCreate.title}' : '',
                  decoration: InputDecoration(
                    hintText: 'Title'
                  ),
                  onChanged: (value) {
                    controller.todoUpdateOrCreate.title = value;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: TextFormField(
                  initialValue: controller.isUpdate ? '${controller.todoUpdateOrCreate.content}' : '',
                  decoration: InputDecoration(
                    hintText: 'Content'
                  ),
                  maxLines: 4,
                  onChanged: (value){
                    controller.todoUpdateOrCreate.content = value;
                  },
                ),
              ),
              Obx((){
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: ListTile(
                    title: Text('${controller.datetimeText.value}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.access_alarms, size: 30,),
                      onPressed: () => pickDateTime(context)
                    ),
                  ),
                );
              }),
              ElevatedButton(
                onPressed: () async {
                  if(controller.isUpdate){
                    await controller.updateTodo(
                      controller.todoUpdateOrCreate.id,
                      controller.todoUpdateOrCreate.title, 
                      controller.todoUpdateOrCreate.content,
                      controller.todoUpdateOrCreate.dueDate.toString()
                    );
                    controller.isUpdate = false;
                  }
                  else{
                    await controller.createTodo(
                      controller.todoUpdateOrCreate.title, 
                      controller.todoUpdateOrCreate.content,
                      controller.todoUpdateOrCreate.dueDate.toString()
                    );
                  }
                  controller.datetimeText.value = 'Due date';
                  Get.back();
                }, 
                child: const Text('Submit')
              ),
            ],
          ),
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
      
      controller.todoUpdateOrCreate.dueDate = controller.datetimePicker!;
      controller.datetimeText.value = DateFormat('dd/MM/yyyy HH:mm').format(controller.todoUpdateOrCreate.dueDate).toString();
    }
    catch(e){
      print(e);
    }
  } 
}
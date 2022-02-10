
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:init_project/app/data/todo.dart';
import 'package:init_project/app/modules/home/controllers/home_controller.dart';
import 'package:init_project/app/modules/home/views/create_todo_screen.dart';
import 'package:init_project/app/modules/home/views/home_view.dart';
import 'package:intl/intl.dart';

class ListTodoScreen extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.amber[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateTodoScreen());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('List Todo'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async{
              await controller.googleLogout();
              Get.to(() => HomeView());
            }, 
            icon: const Icon(Icons.logout)
          ),
        ],
        leading: ElevatedButton(
            onPressed: () {}, 
            child: SizedBox(
              width: 35,
              height: 35,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(controller.currentUser!.photoUrl.toString()),
              ),
            ),
          ),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: controller.getListTodo(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          }
          else if(snapshot.data == null){
            return SizedBox(
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 24),
                  const Text('Please Wait...')
                ],
              ),
            );
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                return Card(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: ListTile(
                      title: Text('${snapshot.data![index].content}',),

                      subtitle: Text(
                        'Due time: ${DateFormat('dd/MM/yyyy - kk:mm:ss').format(snapshot.data![index].dueDate)}',
                      ),
                      onLongPress: (){
                        controller.removeTodo(snapshot.data![index].id.toString());
                      },

                      leading: Checkbox(
                        value: snapshot.data![index].isDone, 
                        onChanged: (value) {
                          controller.updateDone(snapshot.data![index].id, value!);
                        },
                      ),

                      trailing: IconButton(
                        icon: Icon(Icons.star, color: snapshot.data![index].isFavorite? Colors.amber: Colors.grey),
                        onPressed: () {
                          snapshot.data![index].isFavorite
                          ? controller.updateFavorite(snapshot.data![index].id, false)
                          : controller.updateFavorite(snapshot.data![index].id, true);
                        },
                      ),

                      onTap: () {
                        controller.isUpdate = true;
                        controller.todoUpdateOrCreate = snapshot.data![index];
                        controller.datetimeText.value = snapshot.data![index].dueDate.toString();
                        Get.to(() => CreateTodoScreen());
                      },
                    ),
                  ),
                );
              }
            );
          }
        }
      ),
    );
  }
  
}
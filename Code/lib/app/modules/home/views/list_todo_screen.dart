
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:init_project/app/data/todo.dart';
import 'package:init_project/app/modules/home/controllers/home_controller.dart';
import 'package:init_project/app/modules/home/views/create_todo_screen.dart';
import 'package:init_project/app/modules/home/views/home_view.dart';

class ListTodoScreen extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateTodoScreen());
        },
      ),
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
          ),
          ElevatedButton(
            onPressed: () {}, 
            child: SizedBox(
              width: 35,
              height: 35,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(controller.currentUser!.photoUrl.toString()),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<List<Todo>>(
            stream: controller.getListTodo(),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
              else if(snapshot.data == null){
                return Text('Loading');
              }
              else{
                return SingleChildScrollView(
                  child: Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        return Card(
                          child: ListTile(
                            title: Text('${snapshot.data![index].content}'),
                            onLongPress: (){
                              controller.removeTodo(snapshot.data![index].id.toString());
                            },
                          ),
                        );
                      }
                    ),
                  ),
                );
              }
            }
          )
        ],
      ),
    );
  }
  
}
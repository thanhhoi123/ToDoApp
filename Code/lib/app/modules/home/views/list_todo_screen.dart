
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateTodoScreen());
        },
      ),
      appBar: AppBar(
        title: Text('List Todo'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async{
              await controller.googleLogout();
              Get.to(() => HomeView());
            }, 
            icon: Icon(Icons.logout)
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
      body: SingleChildScrollView(
        child: Column(
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          return Card(
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
                                  ? controller.updataFavorite(snapshot.data![index].id, false)
                                  : controller.updataFavorite(snapshot.data![index].id, true);
                                },
                              ),
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
      ),
    );
  }
  
}
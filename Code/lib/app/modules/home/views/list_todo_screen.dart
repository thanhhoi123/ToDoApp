
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:init_project/app/data/todo.dart';
import 'package:init_project/app/modules/home/controllers/home_controller.dart';
import 'package:init_project/app/modules/home/views/create_todo_screen.dart';
import 'package:init_project/app/modules/home/views/home_view.dart';
import 'package:init_project/app/viewmodel/widget/navigation_drawer_widget.dart';
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
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('List Todo'),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: PopupMenuButton(
              child: SizedBox(
                width: 35,
                height: 35,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(controller.currentUser!.photoUrl.toString()),
                ),
              ),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(controller.currentUser!.photoUrl.toString()),
                    ),
                  )
                ),
                PopupMenuItem(
                  child: Text('${controller.currentUser!.email}')
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  child: ListTile(
                    title: Text('Log out'),
                    leading: Icon(Icons.logout),
                    onTap: () async {
                      await controller.googleLogout();
                      Get.to(() => HomeView());
                    },
                  )
                )
              ],
            ),
          ),
        ],
        automaticallyImplyLeading: false,
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
                controller.updateTimeUp(snapshot.data![index].id, snapshot.data![index].dueDate);
                return OpenContainer(
                  transitionDuration: const Duration(seconds: 1),
                  openBuilder: (context, action){
                    controller.isUpdate = true;
                    controller.todoUpdateOrCreate = snapshot.data![index];
                    controller.datetimeText.value = snapshot.data![index].dueDate.toString();
                    return CreateTodoScreen();
                  },
                  closedBuilder: (context, openContainer) => Card(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: ListTile(
                        title: Text(
                          '${snapshot.data![index].content}',
                          style: TextStyle(decoration: snapshot.data![index].isDone == true 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none),
                        ),

                        subtitle: Text(
                          'Due time: ${DateFormat('dd/MM/yyyy - kk:mm:ss').format(snapshot.data![index].dueDate)}',
                          style: TextStyle(color: snapshot.data![index].isTimeUp ? Colors.red : Colors.black),
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
                          openContainer();
                        },
                      ),
                    )
                  )
                );
              }
            );
          }
        }
      ),
    );
  }  
}
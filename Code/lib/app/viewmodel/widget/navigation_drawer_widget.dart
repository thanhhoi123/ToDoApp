import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:init_project/app/modules/home/controllers/home_controller.dart';
import 'package:init_project/app/modules/home/views/home_view.dart';

class NavigationDrawerWidget extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue,
      child: ListView(
        children: <Widget>[
          buildHeader(
            name: controller.currentUser!.displayName.toString(), 
            email: controller.currentUser!.email.toString(), 
            avatar: controller.currentUser!.photoUrl.toString()
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Divider(color: Colors.white),
                const SizedBox(height: 12,),
                buildMenuItem(text: 'Favorite', icon: Icons.favorite_sharp, onClicked: () => selectedItem(context, 0)),
                const SizedBox(height: 16,),
                buildMenuItem(text: 'Label', icon: Icons.label, onClicked: () => selectedItem(context, 1)),
                const SizedBox(height: 16,),
                buildMenuItem(text: 'Dark mode', icon: Icons.dark_mode, onClicked: () => selectedItem(context, 2)),
                const SizedBox(height: 24),
                Divider(color: Colors.white),
                buildMenuItem(text: 'Log out', icon: Icons.logout, onClicked: () => selectedItem(context, 3))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeader({
    required String name,
    required String email,
    required String avatar
  }){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          SizedBox(width: 16,),
          CircleAvatar(backgroundImage: NetworkImage(avatar),),
          SizedBox(width: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4,),
              Text(
                email,
                style: TextStyle(color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }){
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white),),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) async{
    switch(index){
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        await controller.googleLogout();
        Get.to(() => HomeView());
        break;
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:init_project/app/data/todo.dart';

class HomeController extends GetxController {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? currentUser;
  
  final isDone = false.obs;
  
  final initDate = DateTime.now();
  final initTime = TimeOfDay(hour: 6, minute: 0);
  DateTime? datetimePicker;
  final datetimeText = 'Due day'.obs;

  bool isUpdate = false;
  Todo todoUpdateOrCreate = new Todo(
    id: '',
    content: '',
    title: '',
    dueDate: DateTime.now(),
    isDone: false,
    isFavorite: false,
    isTimeUp: false
  );

  bool isDarkMode = false;

  Future googleLogin() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    currentUser = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future googleLogout() async{
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Stream<List<Todo>> getListTodo() => FirebaseFirestore.instance
    .collection('users').doc(currentUser!.id)
    .collection('todos').orderBy('is_done').snapshots()
    .map((snapshot) => snapshot.docs.map((e) => Todo.fromJson(e.data())).toList());

  Future<void> createTodo(String title, String content, String dueDate) async {
    try{
      final docTodo = FirebaseFirestore.instance.collection('users').doc(currentUser!.id).collection('todos').doc();

      final todo = Todo(
        id: docTodo.id,
        title: title,
        content: content,
        dueDate: DateTime.parse(dueDate),
        isDone: false,
        isFavorite: false,
        isTimeUp: false
      );
      final json = todo.toJson();
      
      await docTodo.set(json);
      }
    catch(e){
      print(e.toString());
    }    
  }

  Future<void> updateTodo(String id, String title, String content, String dueDate) async{
    try{
      final docTodo = FirebaseFirestore.instance.collection('users').doc(currentUser!.id).collection('todos').doc(id);
      docTodo.update({
        'title': title,
        'content': content,
        'dueDate': dueDate
      });
    }
    catch(e){

    }
  }

  void removeTodo(String id){
    final docTodo = FirebaseFirestore.instance.collection('users').doc(currentUser!.id).collection('todos').doc(id);
    docTodo.delete();
  }

  void updateDone(String id, bool value){
    final docTodo = FirebaseFirestore.instance.collection('users').doc(currentUser!.id).collection('todos').doc(id);
    docTodo.update({
      'is_done': value
    });
  }

  void updateFavorite(String id, bool value){
    final docTodo = FirebaseFirestore.instance.collection('users').doc(currentUser!.id).collection('todos').doc(id);
    docTodo.update({
      'is_favorite': value
    });
  }

  void updateTimeUp(String id, DateTime dueDay){
    final docTodo = FirebaseFirestore.instance.collection('users').doc(currentUser!.id).collection('todos').doc(id);
    if(dueDay.isBefore(DateTime.now())){
      docTodo.update({
        'is_time_up': true
      });
    }
  }

}

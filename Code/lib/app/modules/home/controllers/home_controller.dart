import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:init_project/app/data/todo.dart';

class HomeController extends GetxController {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? currentUser;

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

  String? contentCreate, titleCreate;

  Future createTodo(String title, String content) async {
    try{
      final docTodo = FirebaseFirestore.instance.collection('users').doc(currentUser!.id).collection('todos').doc();

      final todo = Todo(
        id: docTodo.id,
        title: title,
        content: content,
        dueDate: DateTime.now(),
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

  final isDone = false.obs;

  Stream<List<Todo>> getListTodo() => FirebaseFirestore.instance
    .collection('users').doc(currentUser!.id)
    .collection('todos').snapshots()
    .map((snapshot) => snapshot.docs.map((e) => Todo.fromJson(e.data())).toList());

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
}

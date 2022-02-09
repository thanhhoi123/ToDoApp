import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeController extends GetxController {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;

  Future googleLogin() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    user = googleUser;

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
}

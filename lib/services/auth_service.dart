import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  //SignIn
  signIn(AuthCredential authCredential){
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }
  //Sign out
  signOut(){
    FirebaseAuth.instance.signOut();

  }
}
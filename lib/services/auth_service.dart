
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:groupie/services/database_service.dart';

class AuthService {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUserWithEmailAndPassword(String fullName, String email, String password) async {

    try{
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      )).user!;

      if(user != null) {

        await DatabaseService(uid: user.uid).savingUserData(fullName, email);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future loginUserWithEmailAndPassword(String email, String password) async {

    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      )).user!;

      if(user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {

    try {
      final SharedPreferences sf = await SharedPreferences.getInstance();
      sf.clear();
      firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

}

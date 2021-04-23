import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  var firebaseAuth = FirebaseAuth.instance;

  logout() async {
    final googlesignin = GoogleSignIn();
    await googlesignin.signOut();
    return await firebaseAuth.signOut();
  }

  signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken));
        FirebaseFirestore.instance
            .collection('userData')
            .doc(userCredential.user.uid)
            .set({


  //               final String uid;
  // final String email;
  // final String photoURL;
  // final String displayName;
  // final List skills;
  // final String lastSeen;
  // final String phone;
          "email": userCredential.user.email.toLowerCase(),
          'password': "",
          "displayName": userCredential.user.displayName,
          "uid": userCredential.user.uid,
          'phone': userCredential.user.phoneNumber,
          'dateCreated': DateTime.now(),
          'photoURL': userCredential.user.photoURL,
          'isVerified': true,
        }, SetOptions(merge: true));

        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            message: 'Missing Google Id',
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN');
      }
    } else {
      throw FirebaseAuthException(
          message: 'Sign In aborted by user', code: 'ERROR_ABORTED_BY_USER');
    }
  }
}

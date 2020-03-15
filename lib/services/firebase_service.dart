import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tuition_attendance/main.dart';
import 'package:tuition_attendance/models/models.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
]);
final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

Future<void> login() async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  AuthResult result = await _auth.signInWithCredential(credential);
  createUserDatabase(result.user);
  analytics.logLogin(loginMethod: 'Google SignIn');
}

Future<void> createUserDatabase(FirebaseUser user) async {
  var doc = await _firestore.document('users/${user.uid}').get();
  if (!doc.exists) {
    var userRef = _firestore.document('users/${user.uid}');
    var data = {
      'uid': user.uid,
    };
    userRef.setData(data, merge: true);
  }
}

Future<void> createStudentDatabase(Students user) async {
  // var doc = await _firestore.document('users/${user.uid}').get();
  // if (!doc.exists) {
  //   var userRef = _firestore.document('users/${user.uid}');
  //   var data = {
  //     'uid': user.uid,
  //   };
  //   userRef.setData(data, merge: true);
  // }
}

Stream<User> streamUser(String uid) {
  return _firestore
      .collection('users')
      .document(uid)
      .snapshots()
      .map((snap) => User.fromMap(snap.data));
}

Future<QuerySnapshot> streamStudents(String uid) {
  return _firestore.collection('users/$uid/students').getDocuments();
}

void signOut() {
  _auth.signOut();
  analytics.logEvent(name: 'Logout');
}

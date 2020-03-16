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

Future<void> createStudentDatabase(String uid, Student student) async {
  _firestore.collection('users/$uid/students').add({
    'address': student.address,
    'age': student.age,
    'applicableFees': student.applicableFees,
    'batchTime': student.batchTime,
    'classOfStudy': student.classOfStudy,
    'dateAtWhichStudentGivesFees': student.dateAtWhichStudentGivesFees,
    'dateOfAdmission': student.dateOfAdmission,
    'dateOfLeaving': student.dateOfLeaving,
    'email': student.email,
    'lastGivenFeesDate': student.lastGivenFeesDate,
    'maxTimeFeesNotGivenForMonth': student.maxTimeFeesNotGivenForMonth,
    'feesGiven': student.feesGiven,
    'gender': student.gender,
    'hasLeftTuition': student.hasLeftTuition,
    'mobileNo': student.mobileNo,
    'modeOfPayment': student.modeOfPayment,
    'name': student.name,
    'noOfSiblings': student.noOfSiblings,
    'photo': student.photo,
    'school': student.school,
    'secondaryMobileNo': student.secondaryMobileNo,
    'siblings': student.siblings,
    'totalFeesGiven': student.totalFeesGiven,
    'uid': student.uid,
  }).then((doc) {
    doc.updateData({'uid': doc.documentID});
  });
}

Future<void> updateStudentDatabase(
    String uid, String studentId, Student student) async {
  _firestore.document('users/$uid/students/$studentId').updateData({
    'address': student.address,
    'age': student.age,
    'applicableFees': student.applicableFees,
    'batchTime': student.batchTime,
    'classOfStudy': student.classOfStudy,
    'dateAtWhichStudentGivesFees': student.dateAtWhichStudentGivesFees,
    'dateOfAdmission': student.dateOfAdmission,
    'dateOfLeaving': student.dateOfLeaving,
    'email': student.email,
    'maxTimeFeesNotGivenForMonth': student.maxTimeFeesNotGivenForMonth,
    'lastGivenFeesDate': student.lastGivenFeesDate,
    'feesGiven': student.feesGiven,
    'gender': student.gender,
    'hasLeftTuition': student.hasLeftTuition,
    'mobileNo': student.mobileNo,
    'modeOfPayment': student.modeOfPayment,
    'name': student.name,
    'noOfSiblings': student.noOfSiblings,
    'photo': student.photo,
    'school': student.school,
    'secondaryMobileNo': student.secondaryMobileNo,
    'siblings': student.siblings,
    'totalFeesGiven': student.totalFeesGiven,
    'uid': student.uid,
  });
}

Stream<User> streamUser(String uid) {
  return _firestore
      .collection('users')
      .document(uid)
      .snapshots()
      .map((snap) => User.fromMap(snap.data));
}

Future<QuerySnapshot> streamStudents(String uid, int classOfStudy) {
  return _firestore
      .collection('users/$uid/students')
      .where('classOfStudy', isEqualTo: classOfStudy)
      .getDocuments();
}

void signOut() {
  _auth.signOut();
  analytics.logEvent(name: 'Logout');
}

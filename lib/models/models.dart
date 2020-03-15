import 'package:cloud_firestore/cloud_firestore.dart';

class Students {
  final String email;
  final String photo;
  final String modeOfPayment;
  final String siblings;
  final String uid;
  final String name;
  final String address;
  final String mobileNo;
  final String secondaryMobileNo;
  final String dateOfAdmission;
  final String dateOfLeaving;
  final int classOfStudy;
  final String batchTime;
  final int feesGiven;
  final String dateAtWhichStudentGivesFees;
  final String gender;
  final int applicableFees;
  final String school;
  final double noOfSiblings;
  final bool feesDoneForMonth;
  final int age;
  final int totalFeesGiven;
  final bool hasLeftTuition;
  Students(
      {this.uid,
      this.email,
      this.photo,
      this.name,
      this.address,
      this.mobileNo,
      this.dateOfAdmission,
      this.dateOfLeaving,
      this.modeOfPayment,
      this.classOfStudy,
      this.batchTime,
      this.feesGiven,
      this.applicableFees,
      this.school,
      this.noOfSiblings,
      this.siblings,
      this.feesDoneForMonth,
      this.gender,
      this.dateAtWhichStudentGivesFees,
      this.age,
      this.totalFeesGiven,
      this.hasLeftTuition,
      this.secondaryMobileNo});

  factory Students.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Students(
      uid: data['uid'] ?? '',
      address: data['address'] ?? '',
      applicableFees: data['applicableFees'] ?? 0,
      batchTime: data['batchTime'] ?? '',
      classOfStudy: data['classOfStudy'] ?? 0,
      dateOfAdmission: data['dateOfAdmission'] ?? '',
      dateOfLeaving: data['dateOfLeaving'] ?? '',
      email: data['email'] ?? '',
      feesDoneForMonth: data['feesDoneForMonth'] ?? false,
      feesGiven: data['feesGiven'] ?? 0,
      age: data['age'] ?? 0,
      mobileNo: data['mobileNo'] ?? '',
      modeOfPayment: data['modeOfPayment'] ?? '',
      name: data['name'] ?? '',
      noOfSiblings: data['noOfSiblings'] ?? 0,
      photo: data['photo'] ?? '',
      school: data['school'] ?? '',
      secondaryMobileNo: data['secondaryMobileNo'] ?? '',
      siblings: data['siblings'] ?? '',
      gender: data['gender'] ?? '',
      totalFeesGiven: data['totalFeesGiven'] ?? 0,
      hasLeftTuition: data['hasLeftTuition'] ?? false,
      dateAtWhichStudentGivesFees: data['dateAtWhichStudentGivesFees'] ?? '',
    );
  }
}

class User {
  final String uid;

  User({this.uid});
  factory User.fromMap(Map data) {
    return User(
      uid: data['uid'] ?? '',
    );
  }
}

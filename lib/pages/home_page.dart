import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tuition_attendance/models/models.dart';
import 'package:tuition_attendance/pages/add_student.dart';
import 'package:tuition_attendance/services/firebase_service.dart'
    as firebaseService;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [];

  getStudents(String uid) async {
    QuerySnapshot querySnapshot;
    querySnapshot = await firebaseService.streamStudents(uid);

    var _students = querySnapshot.documents
        .map((data) => Student.fromFirestore(data))
        .toList();
    setState(() {
      students = _students;
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: show slidable tabs for every class students
    User user = Provider.of<User>(context);
    if (user.uid != '') getStudents(user.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students',
          style: GoogleFonts.lato(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => StreamProvider<User>.value(
                      value: firebaseService.streamUser(user.uid),
                      initialData: User.fromMap({}),
                      child: AddStudent(),
                    ),
                  ),
                );
              })
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, idx) => students[idx].photo == ''
            ? ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user.webp'),
                ),
              )
            : ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(students[idx].photo),
                ),
              ),
      ),
    );
  }
}

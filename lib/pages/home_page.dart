import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tuition_attendance/models/models.dart';
import 'package:tuition_attendance/pages/add_student.dart';
import 'package:tuition_attendance/pages/student_details.dart';
import 'package:tuition_attendance/services/firebase_service.dart'
    as firebaseService;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [];
  int _classOfStudy = 1;

  getStudents(String uid) async {
    QuerySnapshot querySnapshot;
    querySnapshot = await firebaseService.streamStudents(uid, _classOfStudy);

    var _students = querySnapshot.documents
        .map((data) => Student.fromFirestore(data))
        .toList();
    setState(() {
      students = _students;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              }),
          Padding(padding: EdgeInsets.only(right: 20)),
          SizedBox(
            width: 100,
            child: FormBuilderDropdown(
              attribute: "class",
              initialValue: '1',
              style: GoogleFonts.lato(color: Colors.black),
              onChanged: (d) {
                setState(() {
                  _classOfStudy = int.parse(d);
                });
                getStudents(user.uid);
              },
              items: [
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10',
                '11',
                '12'
              ]
                  .map(
                    (gender) => DropdownMenuItem(
                      value: gender,
                      child: Text("$gender"),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, idx) => ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => StudentDetails(
                  student: students[idx],
                  uid: user.uid,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: students[idx].photo == ''
                ? AssetImage('assets/images/user.webp')
                : CachedNetworkImageProvider(students[idx].photo),
          ),
          title: Text(
            students[idx].name,
            style: GoogleFonts.lato(),
          ),
          subtitle: Text(
            students[idx].batchTime,
            style: GoogleFonts.lato(),
          ),
          trailing: InkWell(
            onTap: () async {
              String url = "tel:${students[idx].mobileNo}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                students[idx].mobileNo,
                style: GoogleFonts.lato(color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

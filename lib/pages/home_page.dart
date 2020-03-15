import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tuition_attendance/models/models.dart';
import 'package:tuition_attendance/services/firebase_service.dart'
    as firebaseService;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Students> students = [];
  String _filterType = 'All Students';
  String _userUid;

  @override
  void initState() {
    super.initState();
  }

  getProducts() async {
    QuerySnapshot querySnapshot;
    querySnapshot = await firebaseService.streamStudents(_userUid);

    students.addAll(querySnapshot.documents
        .map((data) => Students.fromFirestore(data))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    //TODO: show slidable tabs for every class students
    User user = Provider.of<User>(context);
    setState(() {
      _userUid = user.uid;
    });
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          _filterType,
          style: GoogleFonts.lato(),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {})
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, idx) => ListTile(
          leading: CachedNetworkImage(
            imageUrl: students[idx].photo,
            imageBuilder: (ctx, image) => CircleAvatar(
              backgroundImage: image,
            ),
            placeholder: (context, url) => Center(
              child: Icon(
                FontAwesomeIcons.hourglassHalf,
                color: Colors.grey,
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Icon(
                FontAwesomeIcons.hourglassHalf,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

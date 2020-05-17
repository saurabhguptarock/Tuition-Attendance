import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuition_attendance/models/models.dart';
import 'package:tuition_attendance/pages/edit_student.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDetails extends StatefulWidget {
  final String uid;
  final Student student;

  const StudentDetails({Key key, @required this.uid, @required this.student})
      : super(key: key);
  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.name, style: GoogleFonts.lato()),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => EditStudentDetails(
                    student: widget.student,
                    uid: widget.uid,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              studentDetail('Name', widget.student.name),
              studentDetail('Email', widget.student.email),
              studentDetail('Address', widget.student.address),
              InkWell(
                onTap: () async {
                  String url = "tel:${widget.student.mobileNo}";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: studentDetail('Mobile No.', widget.student.mobileNo),
              ),
              InkWell(
                onTap: () async {
                  String url = "tel:${widget.student.secondaryMobileNo}";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: studentDetail(
                    'Secondary Mobile No.', widget.student.secondaryMobileNo),
              ),
              studentDetail(
                  'Date of Admission', widget.student.dateOfAdmission),
              studentDetail('Date of Leaving', widget.student.dateOfLeaving),
              studentDetail('Mode of Payment', widget.student.modeOfPayment),
              studentDetail(
                  'Class of Study', widget.student.classOfStudy.toString()),
              studentDetail('Batch Time', widget.student.batchTime),
              studentDetail('Fees Given', widget.student.feesGiven.toString()),
              studentDetail(
                  'Applicable Fees', widget.student.applicableFees.toString()),
              studentDetail('School', widget.student.school),
              studentDetail(
                  'No of Siblings', widget.student.noOfSiblings.toString()),
              studentDetail('Siblings', widget.student.siblings),
              studentDetail(
                  'Last fees given date', widget.student.lastGivenFeesDate),
              studentDetail('Max time fees not given for month',
                  widget.student.maxTimeFeesNotGivenForMonth.toString()),
              studentDetail('Gender', widget.student.gender),
              studentDetail('Date at which Student Gives Fees',
                  widget.student.dateAtWhichStudentGivesFees.toString()),
              studentDetail('Age', widget.student.age.toString()),
              studentDetail(
                  'Total Fees Given', widget.student.totalFeesGiven.toString()),
              studentDetail(
                  'Has Left Tuition', widget.student.hasLeftTuition.toString()),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget studentDetail(String name, String data) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            data == '' || data == null ? 'No data' : data,
            style: GoogleFonts.lato(),
          ),
        ],
      ),
    );
  }
}

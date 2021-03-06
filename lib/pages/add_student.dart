import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:tuition_attendance/services/firebase_service.dart'
    as firebaseService;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tuition_attendance/models/models.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  double _noOfSiblings = 0;
  bool _studentLeftTuition = false;
  DateTime _lastFeesGivenDate;
  File _studentImage;
  FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://tuition-attendance-8c2c9.appspot.com');
  StorageUploadTask _uploadTask;
  ProgressDialog pr;

  void startUpload() {
    String filePath = 'students/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_studentImage);
    });
  }

  @override
  void initState() {
    pr = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Download);
    pr.style(
      message: 'Uploading...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: SpinKitCubeGrid(
        color: Color(0xff7160FF),
        size: 50,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: GoogleFonts.lato(
        textStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.bold),
      ),
      messageTextStyle: GoogleFonts.lato(
        textStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.bold),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Students',
          style: GoogleFonts.lato(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: FormBuilder(
                  key: _fbKey,
                  // initialValue: {
                  //   'date': DateTime.now(),
                  //   'accept_terms': false,
                  // },
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'name',
                        autofocus: true,
                        validators: [FormBuilderValidators.required()],
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: "Name of Student"),
                      ),
                      FormBuilderTextField(
                        attribute: 'address',
                        keyboardType: TextInputType.text,
                        validators: [FormBuilderValidators.required()],
                        decoration:
                            InputDecoration(labelText: "Address of Student"),
                      ),
                      FormBuilderTextField(
                        attribute: 'school',
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: "School of Student"),
                      ),
                      FormBuilderTextField(
                        keyboardType: TextInputType.number,
                        attribute: "age",
                        decoration: InputDecoration(labelText: "Age"),
                        validators: [
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.max(70),
                          FormBuilderValidators.required(),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'classOfStudy',
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.required()
                        ],
                        decoration:
                            InputDecoration(labelText: "Class of Student"),
                      ),
                      FormBuilderTextField(
                        attribute: 'mobileNo',
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(10),
                        ],
                        decoration:
                            InputDecoration(labelText: "Mobile no of Student"),
                      ),
                      FormBuilderTextField(
                        attribute: 'secondaryMobileNo',
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.maxLength(10),
                        ],
                        decoration: InputDecoration(
                            labelText: "Secondary mobile no of Student"),
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "dateOfAdmission",
                        inputType: InputType.date,
                        format: DateFormat("dd-MM-yyyy"),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                        decoration:
                            InputDecoration(labelText: "Date Of Admission"),
                      ),
                      FormBuilderTextField(
                        attribute: 'dateAtWhichStudentGivesFees',
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.maxLength(2),
                        ],
                        decoration: InputDecoration(
                            labelText: "Date at which student gives fees"),
                      ),
                      FormBuilderCheckbox(
                        initialValue: false,
                        onChanged: (d) {
                          setState(() {
                            _studentLeftTuition = d;
                          });
                        },
                        attribute: 'hasLeftTuition',
                        label: Text("Does student left the Tuition"),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      if (_studentLeftTuition)
                        FormBuilderDateTimePicker(
                          attribute: "dateOfLeaving",
                          inputType: InputType.date,
                          format: DateFormat("dd-MM-yyyy"),
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          decoration:
                              InputDecoration(labelText: "Date Of Leaving"),
                        ),
                      FormBuilderTextField(
                        attribute: 'email',
                        keyboardType: TextInputType.emailAddress,
                        validators: [FormBuilderValidators.email()],
                        decoration:
                            InputDecoration(labelText: "Email of Student"),
                      ),
                      FormBuilderSlider(
                        attribute: "noOfSiblings",
                        min: 0,
                        max: 10,
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                        initialValue: 0,
                        onChanged: (d) {
                          setState(() {
                            _noOfSiblings = d;
                          });
                        },
                        divisions: 10,
                        decoration:
                            InputDecoration(labelText: "No of Siblings"),
                      ),
                      if (_noOfSiblings > 0)
                        FormBuilderTextField(
                          attribute: "siblings",
                          keyboardType: TextInputType.text,
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          decoration: InputDecoration(labelText: "Siblings"),
                        ),
                      FormBuilderDateTimePicker(
                        attribute: "lastGivenFeesDate",
                        inputType: InputType.date,
                        onChanged: (date) {
                          setState(() {
                            _lastFeesGivenDate = date;
                          });
                        },
                        format: DateFormat("dd-MM-yyyy"),
                        decoration:
                            InputDecoration(labelText: "Last fees given date"),
                      ),
                      FormBuilderTextField(
                        initialValue: '0',
                        readOnly: true,
                        attribute: "maxTimeFeesNotGivenForMonth",
                        decoration: InputDecoration(
                            labelText:
                                "Max time for which fees is not submitted"),
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "batchTime",
                        inputType: InputType.time,
                        format: DateFormat("H:mm"),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                        decoration: InputDecoration(labelText: "Batch Timing"),
                      ),
                      FormBuilderDropdown(
                        attribute: "gender",
                        decoration: InputDecoration(labelText: "Gender"),
                        initialValue: 'Male',
                        hint: Text('Select Gender'),
                        validators: [FormBuilderValidators.required()],
                        items: ['Male', 'Female', 'Other']
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text("$gender"),
                              ),
                            )
                            .toList(),
                      ),
                      FormBuilderTextField(
                        attribute: "applicableFees",
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.required(),
                        ],
                        decoration:
                            InputDecoration(labelText: "Applicable Fees"),
                      ),
                      FormBuilderTextField(
                        keyboardType: TextInputType.number,
                        attribute: "feesGiven",
                        validators: [
                          if (_lastFeesGivenDate != null)
                            FormBuilderValidators.required(),
                        ],
                        decoration: InputDecoration(labelText: "Fees Given"),
                      ),
                      FormBuilderTextField(
                        initialValue: '0',
                        readOnly: true,
                        attribute: "totalFeesGiven",
                        decoration:
                            InputDecoration(labelText: "Total Fees Given"),
                      ),
                      FormBuilderChoiceChip(
                        initialValue: 'Monthly',
                        attribute: "modeOfPayment",
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                        options: [
                          FormBuilderFieldOption(
                              child: Text("Monthly"), value: "Monthly"),
                          FormBuilderFieldOption(
                              child: Text("Advance"), value: "Advance"),
                        ],
                        decoration:
                            InputDecoration(labelText: "Mode of Payment"),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      ListTile(
                        onTap: () async {
                          File _file = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            _studentImage = _file;
                          });
                        },
                        leading: CircleAvatar(
                          backgroundImage: _studentImage == null
                              ? AssetImage('assets/images/user.webp')
                              : FileImage(_studentImage),
                        ),
                        title: Text(
                          'Image of Student',
                          style: GoogleFonts.lato(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: MaterialButton(
                      padding: EdgeInsets.all(0),
                      color: Colors.amber,
                      child: Text(
                        "Submit",
                        style:
                            GoogleFonts.lato(color: Colors.green, fontSize: 18),
                      ),
                      onPressed: () async {
                        if (_fbKey.currentState.saveAndValidate()) {
                          String _downloadUrl;
                          if (_studentImage != null) {
                            pr.show();
                            startUpload();
                            _uploadTask.events.listen((data) {
                              pr.update(
                                progress: double.parse(
                                    ((data.snapshot.bytesTransferred /
                                                data.snapshot.totalByteCount) *
                                            100)
                                        .toStringAsFixed(0)),
                              );
                            });
                            _downloadUrl = await (await _uploadTask.onComplete)
                                .ref
                                .getDownloadURL();
                            await pr.hide();
                          }
                          var data = _fbKey.currentState.value;

                          Student student = Student(
                            uid: data['uid'],
                            address: data['address'],
                            applicableFees: int.parse(data['applicableFees']),
                            batchTime:
                                DateFormat('H:mm').format(data['batchTime']),
                            classOfStudy: int.parse(data['classOfStudy']),
                            dateOfAdmission: DateFormat('dd-MM-yyyy')
                                .format(data['dateOfAdmission']),
                            dateOfLeaving: data['dateOfLeaving'] == null
                                ? ''
                                : DateFormat('dd-MM-yyyy')
                                    .format(data['dateOfLeaving']),
                            email: data['email'],
                            maxTimeFeesNotGivenForMonth:
                                int.parse(data['maxTimeFeesNotGivenForMonth']),
                            lastGivenFeesDate: _lastFeesGivenDate == null
                                ? ''
                                : DateFormat('dd-MM-yyyy')
                                    .format(data['lastGivenFeesDate']),
                            feesGiven: data['feesGiven'] != ''
                                ? int.parse(data['feesGiven'])
                                : 0,
                            age: int.parse(data['age']),
                            mobileNo: data['mobileNo'],
                            modeOfPayment: data['modeOfPayment'],
                            name: data['name'],
                            noOfSiblings: int.parse(
                                data['noOfSiblings'].round().toString()),
                            photo: _studentImage == null ? '' : _downloadUrl,
                            school:
                                data['school'] == null ? '' : data['school'],
                            secondaryMobileNo: data['secondaryMobileNo'],
                            siblings: int.parse(data['noOfSiblings']
                                        .round()
                                        .toString()) >
                                    0
                                ? data['siblings']
                                : '',
                            gender: data['gender'],
                            totalFeesGiven: int.parse(data['totalFeesGiven']),
                            hasLeftTuition: data['hasLeftTuition'],
                            dateAtWhichStudentGivesFees:
                                int.parse(data['dateAtWhichStudentGivesFees']),
                          );
                          firebaseService.createStudentDatabase(
                              user.uid, student);
                          Toast.show('Student succesfully created', context,
                              duration: 5);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    child: MaterialButton(
                      padding: EdgeInsets.all(0),
                      color: Colors.amber,
                      child: Text(
                        "Reset",
                        style:
                            GoogleFonts.lato(color: Colors.red, fontSize: 18),
                      ),
                      onPressed: () {
                        setState(() {
                          _fbKey.currentState.reset();
                          _studentImage = null;
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

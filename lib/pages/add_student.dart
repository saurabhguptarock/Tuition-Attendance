import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  bool _feesDoneForMonth = false;
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
    return Scaffold(
      appBar: AppBar(),
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
                        validators: [FormBuilderValidators.required()],
                        decoration:
                            InputDecoration(labelText: "School of Student"),
                      ),
                      FormBuilderTextField(
                        attribute: 'email',
                        keyboardType: TextInputType.emailAddress,
                        validators: [FormBuilderValidators.email()],
                        decoration:
                            InputDecoration(labelText: "Email of Student"),
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
                      FormBuilderDateTimePicker(
                        attribute: "dateAtWhichStudentGivesFees",
                        inputType: InputType.date,
                        format: DateFormat("dd-MM-yyyy"),
                        validators: [
                          FormBuilderValidators.required(),
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
                      FormBuilderCheckbox(
                        initialValue: false,
                        onChanged: (d) {
                          setState(() {
                            _feesDoneForMonth = d;
                          });
                        },
                        attribute: 'feesDoneForMonth',
                        label: Text("Fees done for the month"),
                        validators: [FormBuilderValidators.required()],
                      ),
                      if (_feesDoneForMonth)
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          attribute: "feesGiven",
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          decoration: InputDecoration(labelText: "Fees Given"),
                        ),
                      FormBuilderDateTimePicker(
                        attribute: "batchTime",
                        inputType: InputType.time,
                        format: DateFormat("h:mm a"),
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
                        initialValue: '0',
                        readOnly: true,
                        attribute: "totalFeesGiven",
                        decoration:
                            InputDecoration(labelText: "Total Fees Given"),
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
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          var data = _fbKey.currentState.value;
                          Students student = Students(
                            uid: data['uid'],
                            address: data['address'],
                            applicableFees: data['applicableFees'],
                            batchTime: data['batchTime'],
                            classOfStudy: data['classOfStudy'],
                            dateOfAdmission: data['dateOfAdmission'],
                            dateOfLeaving: data['dateOfLeaving'],
                            email: data['email'],
                            feesDoneForMonth: data['feesDoneForMonth'],
                            feesGiven: data['feesGiven'],
                            age: data['age'],
                            mobileNo: data['mobileNo'],
                            modeOfPayment: data['modeOfPayment'],
                            name: data['name'],
                            noOfSiblings: data['noOfSiblings'],
                            photo: data['photo'],
                            school: data['school'],
                            secondaryMobileNo: data['secondaryMobileNo'],
                            siblings: data['siblings'],
                            gender: data['gender'],
                            totalFeesGiven: data['totalFeesGiven'],
                            hasLeftTuition: data['hasLeftTuition'],
                            dateAtWhichStudentGivesFees:
                                data['dateAtWhichStudentGivesFees'],
                          );
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
                            pr.dismiss();
                          }
                          firebaseService.createStudentDatabase(student);
                          Toast.show('Student succesfully created', context,
                              duration: 5);
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

import 'dart:convert';

import 'package:dr_app/Helpers/degree.dart';
import 'package:dr_app/Helpers/hospital_lavel.dart';
import 'package:dr_app/Screens/personal_details.dart';
import 'package:dr_app/Widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfessionalDetailsScreen extends StatefulWidget {
  static const roteName = 'prodetails';
  @override
  _ProfessionalDetailsScreenState createState() =>
      _ProfessionalDetailsScreenState();
}

class _ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> {
  TextEditingController _nameController;
  TextEditingController _hospitalController;
  TextEditingController _feeController;
  TextEditingController _regNumberController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  HospitalLavel selectedHosLvl;

  List _myActivities;

  bool _isLoad = false;

  @override
  void initState() {
    super.initState();
    _myActivities = [];
    _nameController = TextEditingController();
    _hospitalController = TextEditingController();
    _feeController = TextEditingController();
    _regNumberController = TextEditingController();
  }

  _tryToSubmit() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    _formKey.currentState.save();
    print(_myActivities);
    print(_nameController.text);
    print(_hospitalController.text);
    print(_feeController.text);
    print(_regNumberController.text);
    print(selectedHosLvl.name);
    try {
      setState(() {
        _isLoad = true;
      });
      final response = await http.put(
          'https://doctor-app-4423c.firebaseio.com/Doctors/${selectedHosLvl.name}/$uid/${_nameController.text}/Clinic_Details.json',
          body: json.encode({
            'Address': _hospitalController.text,
            'Hospital Type': selectedHosLvl.name,
            'drDegree': _myActivities,
            'drName': _nameController.text,
            'imageUrl': '',
            'RegNumber': _regNumberController.text,
            'ConsultationFee': _feeController.text,
            'clinic': true,
          }));
      setState(() {
        _isLoad = false;
      });
      print(json.decode(response.body));
      Navigator.of(context)
          .pushReplacementNamed(PersonalDetails.routeName, arguments: {
        'Hospital Type': selectedHosLvl.name,
        'name': _nameController.text,
      });
    } catch (e) {
      setState(() {
        _isLoad = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final degreeList = Provider.of<Degree>(context).items;
    final hospitalList = Provider.of<HospitalLavelProvider>(context).items;
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Clinic Profile',
                        style: TextStyle(
                            fontSize: 35,
                            color: Color.fromRGBO(108, 99, 255, 1),
                            fontWeight: FontWeight.bold),
                      ),
                      customFormFeild('Full Name', _nameController),
                      customFormFeild('Hospital Address', _hospitalController),
                      customFormFeild('Consultation Fee', _feeController),
                      customFormFeild(
                          'Registration Number', _regNumberController),
                      SizedBox(
                        height: 10,
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        titleText: 'My workouts',
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Please select one or more options';
                          }
                          return null;
                        },
                        dataSource: degreeList,
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        // required: true,
                        hintText: 'Please choose one or more',
                        initialValue: _myActivities,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            _myActivities = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<HospitalLavel>(
                        hint: Text("Select your hospital type"),
                        value: selectedHosLvl,
                        onChanged: (HospitalLavel value) {
                          setState(() {
                            selectedHosLvl = value;
                          });
                        },
                        items: hospitalList.map((HospitalLavel user) {
                          return DropdownMenuItem<HospitalLavel>(
                            value: user,
                            child: Row(
                              children: <Widget>[
                                user.icon,
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  user.name,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _isLoad
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : RaisedButton(
                              padding: EdgeInsets.only(
                                  left: 38, right: 38, top: 12, bottom: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              color: Color.fromRGBO(108, 99, 255, 1),
                              onPressed: () {
                                if (validateField(context)) {
                                  _tryToSubmit();
                                }
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateField(BuildContext context) {
    if (_nameController.text.isEmpty ||
        _hospitalController.text.isEmpty ||
        _feeController.text.isEmpty ||
        _regNumberController.text.isEmpty) {
      CustomSnackBar(context, 'Every field mandatory ', SnackBartype.nagetive);
      return false;
    } else {
      return true;
    }
  }

  Widget customFormFeild(String lable, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: inputDecoration(lable),
    );
  }

  InputDecoration inputDecoration(String lable) {
    return InputDecoration(
        labelText: lable,
        labelStyle: TextStyle(color: Color.fromRGBO(108, 99, 255, 1)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(108, 99, 255, 1),
            width: 2.0,
          ),
        ),
        icon: Icon(
          Icons.lock,
          color: Color.fromRGBO(108, 99, 255, 1),
        ));
  }
}

import 'dart:convert';

import 'package:dr_app/Screens/dashbord.dart';
import 'package:dr_app/Widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonalDetails extends StatefulWidget {
  static const routeName = 'personal-details';
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  TextEditingController _contNumberCOntroller;
  TextEditingController _addressController;
  TextEditingController _genderController;

  bool _isLoad = false;

  String _hospitalLevel = '';
  String _name = '';

  _tryToSubmit() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    print(_contNumberCOntroller.text);
    print(_addressController.text);
    try {
      setState(() {
        _isLoad = true;
      });
      final response = await http.put(
          'https://doctor-app-4423c.firebaseio.com/Doctors/$_hospitalLevel/$uid/$_name/Personal_details.json',
          body: json.encode({
            'contact': _contNumberCOntroller.text,
            'Address': _addressController.text,
          }));
      setState(() {
        _isLoad = false;
      });
      print(json.decode(response.body));
      Navigator.of(context).pushReplacementNamed(Dashbord.routeName);
    } catch (e) {
      setState(() {
        _isLoad = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _contNumberCOntroller = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    print(arguments['Hospital Type']);
    setState(() {
      _hospitalLevel = arguments['Hospital Type'];
      _name = arguments['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
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
                    customFormFeild('Contact Number', _contNumberCOntroller),
                    customFormFeild('Home Address', _addressController),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
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
    );
  }

  Widget customFormFeild(String lable, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: inputDecoration(lable),
    );
  }

  bool validateField(BuildContext context) {
    if (_contNumberCOntroller.text.isEmpty || _addressController.text.isEmpty) {
      CustomSnackBar(context, 'Every field mandatory ', SnackBartype.nagetive);
      return false;
    } else {
      return true;
    }
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

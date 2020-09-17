import 'package:dr_app/Screens/login_screen.dart';
import 'package:dr_app/Screens/professional_details_screen.dart';
import 'package:dr_app/Widgets/registration_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = 'registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoad = false;

  void _submit(String email, String password) async {
    try {
      setState(() {
        _isLoad = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      setState(() {
        _isLoad = false;
      });
      Navigator.of(context)
          .pushReplacementNamed(ProfessionalDetailsScreen.roteName);
      print(userCredential.user.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _isLoad = false;
        });
        print('The account already exists for that email.');
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color.fromRGBO(108, 99, 255, 0.8),
            content: Text('The account already exists for that email.')));
      }
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    'assets/images/singin.png',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Registration',
                  style: TextStyle(
                      fontSize: 35,
                      color: Color.fromRGBO(108, 99, 255, 1),
                      fontWeight: FontWeight.bold),
                ),
                RegistrationForm(_submit, _isLoad),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName),
                    child: Text('Have an already account.'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

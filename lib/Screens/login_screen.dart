import 'package:dr_app/Screens/dashbord.dart';
import 'package:dr_app/Screens/registration_screen.dart';
import 'package:dr_app/Widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoad = false;
  void _submit(String email, String password) async {
    print("email" + email);
    print("password" + password);
    try {
      setState(() {
        _isLoad = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Navigator.of(context).pushReplacementNamed(Dashbord.routeName);
      setState(() {
        _isLoad = false;
      });
      print(userCredential.user.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _isLoad = false;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color.fromRGBO(108, 99, 255, 0.8),
            content: Text('No user found for that email.')));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() {
          _isLoad = false;
        });
        print('Wrong password provided for that user.');
      }
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
                  'Sign In',
                  style: TextStyle(
                      fontSize: 35,
                      color: Color.fromRGBO(108, 99, 255, 1),
                      fontWeight: FontWeight.bold),
                ),
                LoginForm(_submit, _isLoad),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(RegistrationScreen.routeName),
                    child: Text('Create new account'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

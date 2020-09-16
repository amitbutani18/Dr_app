import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) submit;
  final bool isLoad;

  LoginForm(this.submit, this.isLoad);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      widget.submit(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Field must be not empty';
              }
              if (!EmailValidator.validate(value)) {
                return 'Please enter valid email';
              }
            },
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Color.fromRGBO(108, 99, 255, 1)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(108, 99, 255, 1),
                  width: 2.0,
                ),
              ),
              icon: Icon(Icons.email, color: Color.fromRGBO(108, 99, 255, 1)),
            ),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'Password',
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
                )),
          ),
          SizedBox(height: 20),
          widget.isLoad
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RaisedButton(
                  padding:
                      EdgeInsets.only(left: 38, right: 38, top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Color.fromRGBO(108, 99, 255, 1),
                  onPressed: _trySubmit,
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }
}

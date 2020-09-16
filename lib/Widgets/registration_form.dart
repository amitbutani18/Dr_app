import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
  ) submit;
  final bool isLoad;
  RegistrationForm(this.submit, this.isLoad);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cmfPasswordController = TextEditingController();

  String _email;
  String _password;

  void _tryToSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.submit(
        _email.trim(),
        _password.trim(),
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
              onSaved: (value) {
                setState(() {
                  _email = value;
                });
              },
              keyboardType: TextInputType.emailAddress,
              decoration: inputDecoration('Email')),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Password must be not empty';
              }
              if (value.length < 6) {
                return 'Password length more than 6';
              }
            },
            decoration: inputDecoration('Password'),
          ),
          TextFormField(
            controller: _cmfPasswordController,
            obscureText: true,
            validator: (value) {
              if (value != _password) {
                return 'Password not match';
              }
            },
            decoration: inputDecoration('Comfirm password'),
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
                  onPressed: _tryToSubmit,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
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

import 'package:dr_app/Screens/dashbord.dart';
import 'package:dr_app/Screens/login_screen.dart';
import 'package:dr_app/Screens/professional_details_screen.dart';
import 'package:dr_app/Screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
          // ignore: deprecated_member_use
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return Dashbord();
            }
            return LoginScreen();
          }),
      routes: {
        RegistrationScreen.routeName: (context) => RegistrationScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        Dashbord.routeName: (context) => Dashbord(),
        ProfessionalDetailsScreen.roteName: (context) =>
            ProfessionalDetailsScreen(),
      },
    );
  }
}

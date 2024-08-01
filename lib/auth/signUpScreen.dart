import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/auth/loginSceen.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/widgets/roundButton.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  String? _password;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signup(){
    if (_formKey.currentState!.validate()) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Processing Data')));

                    setState(() {
                      loading = true;
                    });

                    _auth
                        .createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString())
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().succssMessage('Successfully registered!');
                    }).onError((error, stackTrace) {
                      if (error.toString() ==
                          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
                        Utils().toastMessage('Email Already in use');
                        setState(() {
                          loading = false;
                        });
                      }

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(error.toString())));
                      print(error);
                    });
                  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up '),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            label: Text('Email'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                            if (!emailRegExp.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text('Password'),
                        ),
                        validator: (value) {
                          _password = value;
                          if (value == null || value.isEmpty) {
                            return 'Enter Password';
                          }
                          if (value == null || value.length < 6) {
                            return 'Must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirm password'),
                        obscureText: true,
                        validator: (value) {
                          if (value != _password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      //we can also implement custom logic for password strength!!
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              RoundButton(
                title: 'Sign Up',
                loading: loading,
                onTap: () {
                  signup();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//2 ways of showing erroe
//using fluttertoast
//in validator of text field
//not all errors can be covered using validator so we can also add flutter toast for safe side.

//or using dialog box(can see it from my notes app)

//eemail already in use
//weak password
//invalid email
//confirm password should be same

//xxxxx

//then:

// The then method is called on the Future returned by createUserWithEmailAndPassword.
// It takes a callback function that will be executed when the Future completes successfully.
// The value parameter of the callback will contain the result of the Future, which in this case would be the user credentials if the account creation is successful.
// Inside the then block, setState is called to update the UI, setting loading to false.

//The onError method is used to handle any errors that occur during the execution of the Future.
// It takes a callback function that will be executed if the Future completes with an error.
// The error parameter contains the error that was thrown.
// In this example, the error is checked to see if it matches the specific error for an email that is already in use ([firebase_auth/email-already-in-use]).
// If the error matches, a toast message is displayed to the user.
// Regardless of the error, setState is called to update the UI and set loading to false.


import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/auth/loginWithPhoneNumber.dart';
import 'package:first_app/auth/signUpScreen.dart';
import 'package:first_app/posts/postScreen.dart';
import 'package:first_app/ui/forgotPasswordScreen.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/widgets/roundButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  String? _password;
  bool loading = false;

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      // Utils().succssMessage('Login Successful');
      setState(() {
        loading = false;
      });
      Utils().succssMessage(value.user!.email.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(),
          ));
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      if (error.toString() ==
          '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {
        Utils().toastMessage('Provide Correct Credentials');
      } else {
        Utils().toastMessage(error.toString());
      }
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
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
                          // helperText: 'john@gmail.com',
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
                        // if (value == null || value.length < 6) {
                        //   return 'Must be at least 6 characters';
                        // }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            RoundButton(
              loading: loading,
              title: 'Login',
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                  login();
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ));
                    },
                    child: Text('Forgot Password')),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    },
                    child: Text('Sign Up'))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginWithPhoneNumber(),
                    ));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text('Login with phone number'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///How does this work?

// To validate the form, use the _formKey created in step 1. You can use the _formKey.currentState() method to access the FormState, which is automatically created by Flutter when building a Form.

// The FormState class contains the validate() method. When the validate() method is called, it runs the validator() function for each text field in the form. If everything looks good, the validate() method returns true. If any text field contains errors, the validate() method rebuilds the form to display any error messages and returns false.
//If all validators return null, the form is considered valid, and you can proceed with form submission, such as sending data to a server or displaying a success message.
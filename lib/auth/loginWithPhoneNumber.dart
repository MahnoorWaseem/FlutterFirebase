import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/auth/verifyCode.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/widgets/roundButton.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                label: Text('Enter your number'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Verify phone number',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                await auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text.toString(),
                  verificationCompleted: (PhoneAuthCredential credential) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (FirebaseAuthException error) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  },
                  codeSent: (String verificationId, int? token) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCodeScreen(
                            verificationId: verificationId,
                          ),
                        ));
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    // Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

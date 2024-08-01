import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/posts/postScreen.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                hintText: 'Enter 6 digit OTP',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        await PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpController.text.toString());

                    FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostScreen(),
                          ));
                    });
                  } catch (e) {
                    //multiple exceptios like wrong otp, network connection problem while entering otp etc

                    debugPrint(e.toString());
                  }
                },
                child: Text('Verify OTP'))
          ],
        ),
      ),
    );
  }
}

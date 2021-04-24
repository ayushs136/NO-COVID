import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpdesk_shift/Screens/authentication/login.dart';
import 'package:helpdesk_shift/Screens/authentication/authentication.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  const SignUp({Key key, this.toggleView}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  bool loading = false;
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  var phonecred;
  signUp() async {
    print(phoneController.text);
    // print(emailController.text);
    if (_formKey.currentState.validate()) {
      auth
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((signedUser) {
        auth.verifyPhoneNumber(
            phoneNumber: "+91" + phoneController.text,
            timeout: Duration(seconds: 60),
            verificationCompleted: (val) {
              setState(() {
                phonecred = val;
              });
            },
            verificationFailed: null,
            codeSent: null,
            codeAutoRetrievalTimeout: null);
        FirebaseFirestore.instance
            .collection('userData')
            .doc(signedUser.user.uid)
            .set({
          "email": emailController.text.trim().toLowerCase(),
          'password': passwordController.text.trim(),
          "displayName": usernameController.text.trim(),
          "uid": signedUser.user.uid,
          'phone': phoneController.text,
          'dateCreated': DateTime.now(),
          'photoURL': '',
          'isVerified': false,
        }, SetOptions(merge: true));
        updateProfileDetails();
        sendVerification();
      });

      // Navigator.pop(context);

    }
  }

  sendVerification() async {
    if (!auth.currentUser.emailVerified) {
      await auth.currentUser.sendEmailVerification();
    }
  }

  updateProfileDetails() {
    auth.currentUser.updateProfile(
      displayName: usernameController.text.trim(),
      // phoneNumber: phoneController.text,
    );
    print("display Name: " + usernameController.text.trim());

    auth.currentUser.updateEmail(emailController.text.trim().toLowerCase());
    auth.currentUser.updatePhoneNumber(phonecred);
  }
/*
    currentUser = {
        displayName:"",
        photoURL:"",
        email:"ayush@gmail.com",
    }

khali hai mtlb null hai

 */

  emailValidator(value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Enter a valid email!';
    }
    return null;
  }

  passwordValidator(value) {
    if (value.isEmpty || value.length < 7) {
      return 'Password must be 6 characters long!';
    }
    return null;
  }

  usernameValidator(value) {
    if (value.isEmpty) {
      return 'Name Can\'t be empty';
    }
    return null;
  }

  confirmPasswordValidator(value) {
    if (value != passwordController.text) {
      return 'Password did not matched!';
    }
    return null;
  }

  phoneValidator(value) {
    // auth.verifyPhoneNumber(
    //   phoneNumber: '+91' + value,
    //   verificationCompleted: (PhoneAuthCredential credential) {},
    //   verificationFailed: (FirebaseAuthException e) {},
    //   codeSent: (String verificationId, int resendToken) {},
    //   codeAutoRetrievalTimeout: (String verificationId) {},
    // );
    if (value.isEmpty || value.length != 10) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading == false
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 50  ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Up to ask for help",
                          style: myStyle(30, Colors.black, FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "No Covid: Help Desk",
                          style: myStyle(30, Colors.blue, FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "We value your time!",
                      style: myStyle(25, Colors.black, FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       border: Border.all(style: BorderStyle.solid),
                    //       borderRadius: BorderRadius.circular(50),
                    //       image: DecorationImage(
                    //           image: AssetImage('assets/img/icon.png'))),
                    //   width: 64,
                    //   height: 64,
                    //   // child: Image.asset('assets/img/icon.png'),
                    // ),
                    // SizedBox(height: 50),
                    Form(
                      key: _formKey,

                      // elevation: 10,
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Card(
                            elevation: 5,
                            // width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              validator: (e) => emailValidator(e),
                              autofocus: true,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,

                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Enter a valid Email",
                                labelStyle: myStyle(
                                    15, Colors.grey[900], FontWeight.w200),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Card(
                            elevation: 5,
                            // width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              validator: (e) => usernameValidator(e),
                              controller: usernameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: InputBorder.none,

                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Enter your Full Name",
                                labelStyle: myStyle(
                                    15, Colors.grey[900], FontWeight.w200),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Card(
                            elevation: 5,
                            // width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              validator: (e) => phoneValidator(e),
                              autofocus: true,
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,

                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Enter a valid Phone Number",
                                labelStyle: myStyle(
                                    15, Colors.grey[900], FontWeight.w200),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Card(
                            elevation: 5,
                            // width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              validator: (e) => passwordValidator(e),
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              obscureText: hidePassword1,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    hidePassword1
                                        ? FontAwesomeIcons.eyeSlash
                                        : FontAwesomeIcons.eye,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hidePassword1 = !hidePassword1;
                                    });
                                  },
                                ),
                                border: InputBorder.none,

                                filled: true,
                                fillColor: Colors.white,
                                labelText:
                                    "Create a new Password (Min. 6 Chars)",
                                labelStyle: myStyle(
                                    15, Colors.grey[900], FontWeight.w200),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Card(
                            elevation: 5,
                            // width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              validator: (e) => confirmPasswordValidator(e),
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmPasswordController,
                              obscureText: hidePassword2,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    hidePassword2
                                        ? FontAwesomeIcons.eyeSlash
                                        : FontAwesomeIcons.eye,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hidePassword2 = !hidePassword2;
                                    });
                                  },
                                ),
                                border: InputBorder.none,

                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Confirm Password",
                                labelStyle: myStyle(
                                    15, Colors.grey[900], FontWeight.w200),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // InkWell(
                    //   onTap: () => signUp(),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width / 2,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         "Register",
                    //         style: myStyle(20, Colors.black, FontWeight.w700),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    RaisedButton(
                      elevation: 10,
                      onPressed: () {
                        signUp();
                      },
                      color: Colors.black,
                      child: Text(
                        "Sign Up",
                        style: myStyle(20, Colors.white, FontWeight.bold),
                      ),
                    ),

                    Text("or"),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        Auth().signInWithGoogle();
                      },
                      text: " Sign up with Google ",
                      elevation: 5,
                    ),
                    SizedBox(height: 30),
                    Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an Account?",
                          style: myStyle(20, Colors.black, FontWeight.w700),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            widget.toggleView();
                            // Navigator.of(context).pop();
                          },
                          child: Text(
                            "Login Now!",
                            style: TextStyle(
                              color: Color(0xff03506f),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "By Signing Up you agree to the",
                          style: myStyle(10, Colors.grey[900]),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Terms of Policy",
                            style:
                                myStyle(10, Color(0xff03506f), FontWeight.w700),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : SpinKitFoldingCube(
              color: Colors.blue[500],
              size: 50.0,
              duration: Duration(milliseconds: 1000),
            ),
    );
  }
}

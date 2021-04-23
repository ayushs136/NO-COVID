import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpdesk_shift/Screens/authentication/authentication.dart';

myStyle(double fontSize,
    [Color color = Colors.white, FontWeight fw = FontWeight.w100]) {
  return GoogleFonts.nunito(
    fontSize: fontSize,
    fontWeight: fw,
    color: color,
  );
}

class Login extends StatefulWidget {
  final Function toggleView;

  const Login({Key key, this.toggleView}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePassword = true;
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  bool isFocused = false;
  bool loading = false;
  String errorMsg = '';
  login() async {
    if (_formKey.currentState.validate()) {
      try {
        FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text);
      } on FirebaseAuthException catch (e) {
        print("THis is the error" + e.toString());
        String errorMessage = '';
        switch (e.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        setState(() {
          errorMsg = errorMessage;
        });
        // if (e.code == 'user-not-found') {
        //   return 'No user found for that email.';
        // } else if (e.code == 'wrong-password') {
        //   return 'Wrong password provided for that user.';
        // } else {
        //   setState(() {
        //     errorMsg = e.toString();
        //   });
        //   print(errorMsg);

        // }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  changeFocus() {
    if (isFocused) {
      setState(() {
        isFocused = false;
      });
    } else {
      setState(() {
        isFocused = true;
      });
    }
  }

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

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading == false
          ? SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(top: 100),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login to buy from ",
                          style: myStyle(30, Colors.black, FontWeight.bold),
                        ),
                        Text(
                          " Aas Pass",
                          style: myStyle(30, Colors.blue, FontWeight.bold),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    // Text(
                    //   "Login Now!",
                    //   style: myStyle(25, Colors.black, FontWeight.bold),
                    // ),
                    // SizedBox(height: 20),
                    // Container(
                    //   width: 64,
                    //   height: 64,
                    //   child: Image.asset('images/incine_icon.png'),
                    // ),
                    // SizedBox(height: 20),

                    // InkWell(
                    //   onTap: () => ,
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width / 2,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         "Login",
                    //         style: myStyle(20, Colors.black, FontWeight.w700),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    // Stack(
                    //   children: [
                    //     Container(
                    //       // color: Colors.black,
                    //       height: MediaQuery.of(context).size.height / 3.5,
                    //       width: MediaQuery.of(context).size.height,
                    //       decoration: BoxDecoration(
                    //           color: Colors.blue[100].withOpacity(0.2),
                    //           borderRadius: BorderRadius.only(
                    //               topRight: Radius.circular(10),
                    //               bottomRight: Radius.circular(10))),
                    //     ),
                    Form(
                      // elevation: 5,
                      // autovalidate: true,
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Card(
                            elevation: isFocused ? 10 : 5,
                            // width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              validator: (value) => emailValidator(value),
                              onTap: () {
                                changeFocus();
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,

                                filled: true,
                                fillColor: Colors.white70,
                                labelText: "Enter your registered email",
                                labelStyle: myStyle(15, Colors.grey[900]),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(height: 20),
                          Card(
                            // width: MediaQuery.of(context).size.width,
                            elevation: isFocused ? 10 : 5,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              validator: (e) => passwordValidator(e),
                              onTap: () {
                                changeFocus();
                              },
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: hidePassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    hidePassword
                                        ? FontAwesomeIcons.eyeSlash
                                        : FontAwesomeIcons.eye,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                ),

                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Enter your password (Min. 6 chars)",
                                labelStyle: myStyle(15, Colors.grey[900]),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                    //   ],
                    // ),
                    SizedBox(height: 20),
                    RaisedButton(
                      elevation: 10,
                      color: Colors.black,
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        "Login",
                        style: myStyle(20, Colors.white, FontWeight.w700),
                      ),
                    ),
                    Text("or"),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        Auth().signInWithGoogle();
                      },
                      text: " Sign In with Google ",
                      elevation: 5,

                      // mini: true,
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            // shadows: <Shadow>[
                            //   Shadow(
                            //     offset: Offset(1.0, 1.0),
                            //     blurRadius: 3.0,
                            //     // color: Color.fromARGB(255, 0, 0, 0),
                            //   ),
                            // Shadow(
                            //   offset: Offset(1.0, 1.0),
                            //   blurRadius: 8.0,
                            //   // color: Color.fromARGB(125, 0, 0, 255),
                            // ),
                            // ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            widget.toggleView();
                            //    Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => SignUp()),
                            // );
                          },
                          child: Text(
                            "Register Now!",
                            style: TextStyle(
                              color: Color(0xff03506f),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            // style: myStyle(20, Color(0xff03506f), FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                    ),

                    // Divider(color: Colors.grey),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/models/skills.dart';
import 'package:helpdesk_shift/screens/authentication/auth_services.dart';
import 'package:helpdesk_shift/screens/authentication/provider_widget.dart';

class UserProfile extends StatefulWidget {
  final Helper helper;
  UserProfile({this.helper});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final newHelper = new Helper();
  final newSkills = new Skills();
  var userData;

  updateAvailability(bool isAvailable) async {
    Map<String, bool> data = Map();

    data['isAvailable'] = isAvailable;

    final uid = await ProviderWidget.of(context).auth.getCurrentUID();
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   setState(() {
  //     var fb = FirebaseAuth.instance.currentUser;
  //     userData = FirebaseFirestore.instance
  //         .collection('userData')
  //         .where('uid', isEqualTo: fb.uid)
  //         .snapshots();
  //     // Helper.fromMap(userData.data());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Future<Helper> getHelperData(BuildContext context) async {
    //   // Helper Helper = Helper();
    //   // final uid = await ProviderWidget.of(context).auth.getCurrentUID();
    //   var fb = FirebaseAuth.instance.currentUser;
    //   var userData = await FirebaseFirestore.instance
    //       .collection('userData')
    //       .doc(fb.uid)
    //       .snapshots();
    //   print(userData.data()['name']);
    //   // Helper.fr

    //   return
    // }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('userData')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(snapshot.data.docs[0].data());
          print(snapshot.data.data()['displayName']);
          return Scaffold(
            // floatingActionButton: RaisedButton(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(18.0),
            //       side: BorderSide(color: Colors.black)),
            //   color: Colors.teal,
            //   child: Icon(Icons.edit),
            //   onPressed: () {},
            // ),

            backgroundColor: Color(0xff000000),
            appBar: AppBar(
              // leading: FlatButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => UpdateSkills(
              //                     helper: newHelper,
              //                     skills: newSkills,
              //                   )));
              //     },
              //     child: Icon(
              //       Icons.edit,
              //       color: Colors.white,
              //     )),
              actions: [
                // Column(
                //   children: [
                //     FlatButton(
                //       child: Icon(
                //         Icons.logout,
                //         color: Colors.white,
                //         size: 20,
                //       ),
                //       onPressed: () async {
                //         try {
                //           AuthServices auth = ProviderWidget.of(context).auth;
                //           await auth.signOut();
                //           print("Signed out");
                //         } catch (e) {
                //           print(e + " error siging out");
                //         }
                //       },
                //     ),
                //     Flexible(
                //         child: Text(
                //       "Logout",
                //       style: TextStyle(fontSize: 12),
                //     ))
                //   ],
                // ),
              ],
              centerTitle: true,
              title: Text(
                "${snapshot.data.data()['displayName'].toString().toUpperCase()}'S PROFILE",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Color(0xff000000),
              elevation: 10.0,
              shadowColor: Colors.grey[500],
              // actions: <Widget>[
              //   ListTile(
              //     title: Text(
              //     '${userData.displayName}',
              //       style: TextStyle(
              //         fontSize: 30,
              //       ),
              //     ),
              //     subtitle: Text(
              //       userData.email,
              //       style: TextStyle(fontSize: 30),
              //     ),
              //   ),
              // ]),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(
                          // 'https://lh3.googleusercontent.com/-5axQsnH1ZuM/AAAAAAAAAAI/AAAAAAAAAAA/xAYbnZ7p5AM/s190-p/photo.jpg',
                          snapshot.data.data()['photoURL'] == ''
                              ? 'https://static.thenounproject.com/png/538846-200.png'
                              : snapshot.data.data()['photoURL'],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[800],
                      height: 60.0,
                    ),
                    Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      snapshot.data.data()['displayName'] == null
                          ? ""
                          : snapshot.data
                              .data()['displayName']
                              .toString()
                              .toUpperCase(),
                      style: TextStyle(
                        color: Colors.amberAccent[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                    // SizedBox(height: 30.0),
                    // Text(
                    //   'Last Seen',
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     letterSpacing: 2.0,
                    //   ),
                    // ),

                    SizedBox(height: 30.0),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      // "${(snapshot.data.skills == null) ? 'N/A' : (snapshot.data.skills[0]) + " | " + snapshot.data.skills[1] + " | " + snapshot.data.skills[2] + " | " + snapshot.data.skills[3]}",
                      snapshot.data.data()['email'],
                      // snapshot.data.skills[0] +
                      //     "\n" +
                      //     snapshot.data.skills[1] +
                      //     "\n" +
                      //     snapshot.data.skills[2] +
                      //     "\n" +
                      //     snapshot.data.skills[3],

                      // '8',
                      style: TextStyle(
                        color: Colors.amberAccent[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    // Row(
                    //   children: <Widget>[
                    //     Icon(
                    //       Icons.email,
                    //       color: Colors.grey[400],
                    //     ),
                    //     SizedBox(width: 10.0),
                    //     Text(
                    //       snapshot.data.data()['email'],
                    //       // 'chun.li@thenetninja.co.uk',
                    //       style: TextStyle(
                    //         color: Colors.grey[400],
                    //         fontSize: 15.0,
                    //         letterSpacing: 1.0,
                    //       ),
                    //     ),
                    //     SizedBox(width: 20.0),
                    //   ],
                    // ),

                    // SizedBox(height: 20.0),
                    // Text(
                    //   "\nIs Available?",
                    //   style: TextStyle(
                    //     color: Colors.grey[400],
                    //     fontSize: 20.0,
                    //     letterSpacing: 2.0,
                    //   ),
                    // ),

                    SwitchListTile(
                      value: snapshot.data.data()['isAvailable'],
                      // secondary: Icon(
                      //   FontAwesomeIcons.dashcube,
                      //   color: Colors.grey[400],
                      // ),
                      title: Text(
                        "Allowed to be contacted",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15.0,
                          // letterSpacing: 2.0,
                        ),
                      ),
                      subtitle: Text(
                        "(Off: Stop getting new messages.\n On: Anyone can message you.)",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15.0,
                        ),
                      ),

                      activeColor: Colors.white,
                      // hoverColor: Colors.black,
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.red,
                      onChanged: (bool val) {
                        setState(() {
                          snapshot.data.data()['isAvailable'] = val;
                        });
                        updateAvailability(val);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(color: Colors.grey),
                    FlatButton(
                      color: Colors.yellow,
                      onPressed: () async {
                        try {
                          AuthServices auth = ProviderWidget.of(context).auth;
                          await auth.signOut();
                          print("Signed out");
                        } catch (e) {
                          print(e + " error siging out");
                        }
                      },
                      child: Text(
                        "LOGOUT",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    // Container(
                    //   width: 100,
                    //   height: 50,
                    //   color: Colors.yellow,
                    //   child: ListTile(
                    //     onTap: () async {
                    //       try {
                    //         AuthServices auth = ProviderWidget.of(context).auth;
                    //         await auth.signOut();
                    //         print("Signed out");
                    //       } catch (e) {
                    //         print(e + " error siging out");
                    //       }
                    //     },
                    //     title: Text(
                    //       "LOGOUT",
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 15.0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
      },
    );
  }
}

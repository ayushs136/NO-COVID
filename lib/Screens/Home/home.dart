// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import 'package:helpdesk_shift/Screens/Authenticate/authentication.dart';
// import 'package:helpdesk_shift/Screens/Home/helper_list.dart';
// import 'package:helpdesk_shift/Screens/Home/search.dart';

// import 'package:helpdesk_shift/Screens/Home/side_drawer.dart';
// import 'package:helpdesk_shift/models/helper.dart';
// import 'package:helpdesk_shift/services/database.dart';

// import 'package:provider/provider.dart';

// // import 'helper_tile.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//    var firebaseAuth = FirebaseAuth.instance;
//     logout() async {
//     final googlesignin = GoogleSignIn();
//     await googlesignin.signOut();
//     return await firebaseAuth.signOut();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<List<Helper>>.value(
//         value: DatabaseServices().userDetails,
//         child: Scaffold(
//           drawer: SideBarMenu(),
//           appBar: AppBar(
            
//             title: Text("Help Desk"),
//             actions: <Widget>[
        
//               FlatButton.icon(
//                   onPressed: () {
//                     dynamic results = logout();
//                     print("SignOut Button pressed " + results);
//                   },
//                   label: Text("Logout"),
//                   icon: Icon(Icons.settings_power)),
//             ],
//           ),
//           body: HelperList(),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               SearchScreen();
//             },
//             child: Icon(Icons.search),
//           ),
        
        
        
//         ));
//   }
// }

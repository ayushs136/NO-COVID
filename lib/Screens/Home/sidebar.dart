import 'package:flutter/material.dart';
import 'package:helpdesk_shift/provider/assets.dart';
import 'package:helpdesk_shift/screens/home/user_profile.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SideBarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
             
              children: [
            
              Stack(
                children: [
                  Container(
                    height: 50,
                    width: 100,
                    child: Image.asset(
                      Assets.covidBackground ,
                    ),

                  ),
                ],
              ),
              
              Text(
                
                "No Covid:\nHelp Desk",
                
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ]),
          ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(
              'How to use',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Home()),
              // );
            },
          ),
          ListTile(
            title: Text(
              'Your Profile',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
          // ListTile(
          //   title: Text(
          //     'Settings',
          //     style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Home()),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: Text(
          //     'Search',
          //     style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SearchScreen()),
          //     );
          //   },
          // ),
          ListTile(
              title: Text(
                'Volunteer with Us',
                style: TextStyle(fontSize: 20, color: Colors.grey[600]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text(
                                "Volunteer with Us",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            body: WebView(
                              initialUrl: 'https://imkronos.me',
                            ),
                          )),
                );
              }),
              ListTile(
                title: Text("Connect here for support:\nkronosa136@gmail.com"),
              )
        ],
      ),
    );
  }
}

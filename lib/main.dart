import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_shift/Screens/Home/navigation_view.dart';

import 'package:helpdesk_shift/Screens/wrapper.dart';
import 'package:helpdesk_shift/provider/image_upload_provider.dart';
import 'package:helpdesk_shift/provider/user_provider.dart';
import 'package:helpdesk_shift/screens/authentication/auth_services.dart';
import 'package:helpdesk_shift/screens/authentication/provider_widget.dart';
import 'package:helpdesk_shift/screens/authentication/sign_up.dart';


import 'package:helpdesk_shift/screens/splash_screen.dart';
import 'package:helpdesk_shift/shared/loading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSigned = false;

  @override
  void initState() {
    super.initState();
    // initializeFCM();
    FirebaseAuth.instance.authStateChanges().listen((useraccount) {
      if (useraccount != null) {
        setState(() {
          isSigned = true;
        });
      } else {
        setState(() {
          isSigned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      auth: AuthServices(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ImageUploadProvider>(
            create: (context) => ImageUploadProvider(),
          ),
          ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Help Desk 2.0',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            "/signUp": (BuildContext context) =>
                SignUpView(authFormType: AuthFormType.signUp),
            "/signIn": (BuildContext context) =>
                SignUpView(authFormType: AuthFormType.signIn),
            "/home": (BuildContext context) => HomeController(),
            "/anonymousSignIn": (BuildContext context) => SignUpView(
                  authFormType: AuthFormType.anonymous,
                ),
            "/convertUser": (BuildContext context) =>
                SignUpView(authFormType: AuthFormType.convert),
          },
        ),
      ),
    );
  }
}

class HomeController extends StatefulWidget {
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  bool isSigned = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((useraccount) {
      if (useraccount != null) {
        setState(() {
          isSigned = true;
        });
      } else {
        setState(() {
          isSigned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices auth = ProviderWidget.of(context).auth;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return isSigned == false ? Wrapper() : NavigationView();
        }
        return Loading();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

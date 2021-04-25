import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpdesk_shift/Screens/Home/sidebar.dart';

import 'package:helpdesk_shift/screens/home/chat_screens/widgets/comments.dart';
import 'package:helpdesk_shift/screens/home/addPost.dart';

import 'package:helpdesk_shift/screens/home/helpers_profile.dart';
import 'package:helpdesk_shift/screens/home/user_profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:share/share.dart';

import 'package:timeago/timeago.dart' as tAgo;

// import 'package:helpdesk_shift/models/helper.dart';
// import 'package:helpdesk_shift/screens/home/ad.dart' as ad;
// import 'package:helpdesk_shift/screens/home/chat_screens/widgets/cached_image.dart';
// import 'package:helpdesk_shift/screens/home/friend_requests.dart';
// import 'package:helpdesk_shift/screens/home/helpers_profile.dart';
// import 'package:helpdesk_shift/screens/home/user_profile.dart';

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  var db = FirebaseFirestore.instance;
  Stream<QuerySnapshot> postCollection;

  bool darkMode = true;
  bool all = true, oxy = false, plasma = false, medicine = false;
  var cityName;

  getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    cityName = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    cityName = cityName.first;
    var x = cityName.addressLine.toString();
    cityName = x.toString().split(",").reversed.toList()[2].trim();
    setState(() {
      cityName = cityName;
      // cityName = "${cityName.featureName} : ${cityName.addressLine}";
    });
    // x = x.addressLine.toString();
    print(x.toString().split(",").reversed.toList()[2]);

    getTweetStream();
  }

  getTweetStream() async {
    setState(() {
      postCollection = db
          .collection("posts")
          .where("visible", isEqualTo: true)
          .where("city", isEqualTo: cityName)
          .orderBy('time', descending: true)
          .limit(50)
          .snapshots();
    });
  }

  // getCurrentUserUid() async {
  //   var firebaseuser = FirebaseAuth.instance.currentUser;
  //   setState(() {
  //     uid = firebaseuser.uid;
  //   });
  // }
  //
  initState() {
    super.initState();
    getLocation();
    getTweetStream();
  }

  @override
  Widget build(BuildContext context) {
    // Stream tweetStream;
    // String uid;
    // CollectionReference postCollection =
    //     FirebaseFirestore.instance.collection("posts");

    return Scaffold(
      drawer: SideBarMenu(),
      backgroundColor: darkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          "NO COVID: HELP DESK",
          style: TextStyle(color: darkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        bottomOpacity: 40,
        backgroundColor: darkMode ? Colors.black : Colors.white,
        shadowColor: Colors.grey[500],
        elevation: 20,
        // leading: InkWell(
        //   onTap: () {
        //     // showDialog(
        //     //   context: context,
        //     //   barrierDismissible: false,
        //     //   builder: (_) => UpdateDialog(
        //     //     dialogText: "",
        //     //     fileURL: "",
        //     //   ),
        //     // );
        //     SideBarMenu();
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(FontAwesomeIcons.userFriends,
        //         color: darkMode ? Colors.white : Colors.black),
        //   ),
        // ),
        actions: [
          IconButton(
              icon: Icon(Icons.location_on_rounded, color: Colors.blue),
              onPressed: () {
                print(cityName);
                getLocation();
              }),
          Center(
              child: Text(
                  cityName == null
                      ? "Turn on\nLocation\n& tap on icon"
                      : (cityName.length > 20
                          ? cityName.substring(0, 9) + "..."
                          : cityName),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: cityName == null ? 10 : 15,
                  ))),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Switch(
          //     activeTrackColor: Colors.white,
          //     activeColor: Colors.black,
          //     inactiveTrackColor: Colors.black,
          //     inactiveThumbColor: Colors.white,
          //     value: darkMode,
          //     onChanged: (bool val) {
          //       setState(() {
          //         darkMode = val;
          //         // print(darkMode);
          //       });
          //     },
          //   ),
          // ),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => FriendRequests()));
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Icon(FontAwesomeIcons.redditSquare,
          //         color: darkMode ? Colors.white : Colors.black),
          //   ),
          // )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 120,
            width: 400,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddPost()));
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ask for help by tapping here!",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 8.0),
                      child: Text(
                        "Add a new post to request from Donor.\n(Verification of post takes about 30 minutes)",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                color: Color(0xff099FFF),
              ),
            ),
          ),
          Card(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      all = true;
                      oxy = false;
                      plasma = false;
                      medicine = false;
                      postCollection = db
                          .collection("posts")
                          .where("visible", isEqualTo: true)
                          .where("city", isEqualTo: cityName)
                          .orderBy('time', descending: true)
                          .limit(50)
                          .snapshots();
                    });

                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) => super.widget));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      backgroundColor:
                          all == true ? Colors.yellow : Colors.white,
                      label: Text("All",
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      plasma = true;
                      all = false;
                      oxy = false;
                      medicine = false;
                      postCollection = db
                          .collection("posts")
                          .where("visible", isEqualTo: true)
                          .where("city", isEqualTo: cityName)
                          .where("plasma", isEqualTo: true)
                          .orderBy('time', descending: true)
                          .limit(50)
                          .snapshots();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      backgroundColor:
                          plasma == true ? Colors.purple : Colors.white,
                      label: Text("Plasma",
                          style: TextStyle(
                            color: plasma == true ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      oxy = true;
                      plasma = false;
                      all = false;
                      medicine = false;
                      postCollection = db
                          .collection("posts")
                          .where("visible", isEqualTo: true)
                          .where("city", isEqualTo: cityName)
                          .where("oxygen", isEqualTo: true)
                          .orderBy('time', descending: true)
                          .limit(50)
                          .snapshots();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      backgroundColor:
                          oxy == true ? Colors.green : Colors.white,
                      label: Text("Oxygen",
                          style: TextStyle(
                            color: oxy == true ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      medicine = true;
                      oxy = false;
                      plasma = false;
                      all = false;
                      postCollection = db
                          .collection("posts")
                          .where("visible", isEqualTo: true)
                          .where("city", isEqualTo: cityName)
                          .where("medicine", isEqualTo: true)
                          .orderBy('time', descending: true)
                          .limit(50)
                          .snapshots();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      backgroundColor:
                          medicine == true ? Colors.pinkAccent : Colors.white,
                      label: Text("Medicine",
                          style: TextStyle(
                            color:
                                medicine == true ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          PostStream(
              darkMode: darkMode,
              collection: postCollection,
              cityName: cityName),
        ],
      )),
    );
  }
}

class PostStream extends StatefulWidget {
  // final Stream userStream;
  // final String uid;
  bool darkMode;
  Stream collection;
  String cityName;
  PostStream(
      {Key key, this.darkMode, this.collection, this.cityName = "Gwalior"})
      : super(key: key);
  // const PostStream({Key key, this.userStream, this.uid}) : super(key: key);
  @override
  _PostStreamState createState() => _PostStreamState();
}

class _PostStreamState extends State<PostStream> {
  Stream tweetStream;
  String uid;
  // bool darkMode = false;
  CollectionReference postCollection;

  String likedName = '';
  getTweetStream() async {
    setState(() {
      // tweetStream = postCollection
      //     .where("visible", isEqualTo: true)
      //     .orderBy('time', descending: true)
      //     .snapshots();
      tweetStream = widget.collection;
    });
  }

  getCurrentUserUid() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = firebaseuser.uid;
      postCollection = FirebaseFirestore.instance.collection("posts");
    });
  }

  initState() {
    super.initState();
    getCurrentUserUid();
    getTweetStream();
  }

  // var postCollection = FirebaseFirestore.instance.collection('posts');
  likepost(String documentId) async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot =
        await postCollection.doc(documentId).get();

    if (documentSnapshot['likes'].contains(firebaseuser.uid)) {
      postCollection.doc(documentId).update({
        'likes': FieldValue.arrayRemove([firebaseuser.uid]),
      });
    } else {
      postCollection.doc(documentId).update({
        'likes': FieldValue.arrayUnion([firebaseuser.uid]),
      });
    }
  }

  sharePost(String documentid, String tweet) async {
    Share.share(tweet);
    DocumentSnapshot documentSnapshot =
        await postCollection.doc(documentid).get();
    postCollection
        .doc(documentid)
        .update({'shares': documentSnapshot['shares'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    // bool isPressed = false;
    return StreamBuilder(
        stream: widget.collection,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "Getting posts...",
                    style: myStyle(20, Colors.white, FontWeight.bold),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> helperDoc = snapshot.data.docs[index].data();
              // FirebaseFirestore.instance
              //     .collection("userData")
              //     .doc(helperDoc.data()['likes'][0].toString())
              //     .get()
              //     .then((val) => {
              //           setState(() {
              //             // likedName = val.data()['name'];
              //           })
              //         });

              {
                return Column(
                  children: [
//
                    Card(
                      elevation: 30,

                      // borderOnForeground: true,
                      shadowColor:
                          widget.darkMode ? Colors.grey[500] : Colors.black,
                      color: widget.darkMode ? Colors.black : Colors.white,
                      // decoration: BoxDecoration(
                      //   // borderRadius: BorderRadius.circular(8.0),
                      //
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: widget.darkMode ? Colors.white : Colors.black,
                      //       blurRadius: 2.0,
                      //       spreadRadius: 0.0,
                      //       offset: Offset(
                      //           2.0, 2.0), // shadow direction: bottom right
                      //     )
                      //   ],
                      // ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 8.0, 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        var tempUID = helperDoc['uid'];

                                        if (tempUID != uid) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HelperProfile(
                                                  // helper: Helper.fromMap(
                                                  //     helperDoc.data()
                                                  //     ),
                                                  helperUid: tempUID,
                                                ),
                                              ));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfile(),
                                              ));
                                        }
                                      },
                                      child: new Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(
                                                  helperDoc['photoURL'] == null
                                                      ? ''
                                                      : helperDoc['photoURL'])),
                                        ),
                                      ),
                                    ),
                                    new SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          helperDoc['username'],
                                          style: TextStyle(
                                              color: widget.darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          tAgo
                                              .format(
                                                  helperDoc['time'].toDate())
                                              .toString(),
                                          style: myStyle(
                                              10, Colors.grey, FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                new IconButton(
                                  icon:
                                      Icon(Icons.more_vert, color: Colors.grey),
                                  onPressed: null,
                                )
                              ],
                            ),
                            
                          ),
                          Divider(color: Colors.grey[800],),  
                          if (helperDoc['type'] == 1)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                helperDoc['tweet'],
                                textAlign: TextAlign.justify,
                                style: myStyle(
                                    15,
                                    widget.darkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontWeight.w400),
                              ),
                            ),
                          if (helperDoc['type'] == 2)
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                // fit: FlexFit.loose,
                                child: CachedNetworkImage(
                                  imageUrl: helperDoc['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (helperDoc['type'] == 3)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    helperDoc['tweet'],
                                    style: myStyle(
                                        12,
                                        widget.darkMode
                                            ? Colors.white
                                            : Colors.black,
                                        FontWeight.w400),
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (c) {
                                      return Scaffold(
                                          backgroundColor: widget.darkMode
                                              ? Colors.white
                                              : Colors.black,
                                          body: Center(
                                            child: Hero(
                                              tag: 'picHero' + helperDoc['id'],
                                              child: CachedNetworkImage(
                                                  imageUrl:
                                                      helperDoc['image'] == null
                                                          ? ''
                                                          : helperDoc['image']),
                                            ),
                                          ));
                                    }));
                                  },
                                  onDoubleTap: () {
                                    likepost(helperDoc['id']);
                                  },
                                  child: InteractiveViewer(
                                    maxScale: 5.0,
                                    child: SafeArea(
                                      // fit: FlexFit.loose,
                                      child: Hero(
                                        tag: 'picHero' + helperDoc['id'],
                                        child: CachedNetworkImage(
                                          imageUrl: helperDoc['image'] == null
                                              ? ''
                                              : helperDoc['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey[800],),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // InkWell(
                                    //   onTap: () => likepost(helperDoc['id']),
                                    //   child: Row(
                                    //     children: [
                                    //       // SizedBox(height: 30),
                                    //       // Divider(
                                    //       //   color: Colors.grey,
                                    //       // ),
                                    //       helperDoc['likes'].contains(uid)
                                    //           ? Icon(
                                    //               Icons.favorite,
                                    //               color: Colors.red,
                                    //               // size: 20,
                                    //             )
                                    //           : Icon(
                                    //               FontAwesomeIcons.heart,
                                    //               color: widget.darkMode
                                    //                   ? Colors.white
                                    //                   : Colors.black,
                                    //               // size: 20,
                                    //             ),
                                    //       SizedBox(width: 10.0),
                                    //       Text(
                                    //         (helperDoc['likes'].length + 1)
                                    //             .toString(),
                                    //         style: myStyle(
                                    //             15,
                                    //             widget.darkMode
                                    //                 ? Colors.white
                                    //                 : Colors.black,
                                    //             FontWeight.bold),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // new SizedBox(
                                    //   width: 16.0,
                                    // ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentsPage(
                                                          helperDoc['id']))),
                                          icon: Icon(
                                            Icons.message,
                                            size: 25,
                                          ),
                                          color: widget.darkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          helperDoc['commentsCount'].toString(),
                                          style: myStyle(
                                              15,
                                              widget.darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    new SizedBox(
                                      width: 16.0,
                                    ),
                                    Row(
                                      children: [
                                        FlatButton.icon(
                                          label: Text(
                                            "Share",
                                            style: myStyle(
                                                15,
                                                widget.darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                FontWeight.bold),
                                          ),
                                          onPressed: () => sharePost(
                                              helperDoc['id'],
                                              helperDoc['tweet']),
                                          icon: Icon(
                                            Icons.share,
                                            size: 25,
                                            color: widget.darkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          color: widget.darkMode
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 10.0),
                                        // Text(
                                        //   helperDoc['shares'].toString(),
                                        //   style: myStyle(
                                        //       15,
                                        //       widget.darkMode
                                        //           ? Colors.white
                                        //           : Colors.black,
                                        //       FontWeight.bold),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                // new Icon(
                                //   FontAwesomeIcons.bookmark,
                                //   color: widget.darkMode
                                //       ? Colors.white
                                //       : Colors.black,
                                // ),
                                Row(
                                  children: [
                                    helperDoc['plasma'] == true
                                        ? Chip(
                                            shadowColor: Colors.purple,
                                            elevation: 5,
                                            backgroundColor: Colors.purple,
                                            labelPadding: EdgeInsets.all(2.0),
                                            // avatar: CircleAvatar(
                                            //   backgroundColor: Colors.white70,
                                            //   child: Icon(Icons.circle, color: Colors.red,),
                                            // ),
                                            label: Text(
                                              " Plasma ",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(width: 10),
                                    helperDoc['oxygen'] == true
                                        ? Chip(
                                            shadowColor: Colors.green,
                                            elevation: 5,
                                            backgroundColor: Colors.green,
                                            labelPadding: EdgeInsets.all(2.0),
                                            // avatar: CircleAvatar(
                                            //   backgroundColor: Colors.white70,
                                            //   child: Icon(Icons.circle, color: Colors.red,),
                                            // ),
                                            label: Text(
                                              " Oxygen ",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(width: 10),
                                    helperDoc['medicine'] == true
                                        ? Chip(
                                            shadowColor: Colors.pink,
                                            elevation: 5,
                                            backgroundColor: Colors.pink,
                                            labelPadding: EdgeInsets.all(2.0),
                                            // avatar: CircleAvatar(
                                            //   backgroundColor: Colors.white70,
                                            //   child: Icon(Icons.circle, color: Colors.red,),
                                            // ),
                                            label: Text(
                                              "Medicine",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Location: " +
                                  (helperDoc['city']).toString() +
                                  ", " +
                                  (helperDoc['state']).toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: widget.darkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: <Widget>[
                          //       new Container(
                          //         height: 40.0,
                          //         width: 40.0,
                          //         decoration: new BoxDecoration(
                          //           shape: BoxShape.circle,
                          //           image: new DecorationImage(
                          //               fit: BoxFit.fill,
                          //               image: new NetworkImage(
                          //                   "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                          //         ),
                          //       ),
                          //       new SizedBox(
                          //         width: 10.0,
                          //       ),
                          //       Expanded(
                          //         child: new TextField(
                          //           decoration: new InputDecoration(
                          //             border: InputBorder.none,
                          //             hintText: "Add a comment...",
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 10),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                );
              }
              // else{
              //   CircularProgressIndicator();
              // }
            },
          );
        });
  }
}

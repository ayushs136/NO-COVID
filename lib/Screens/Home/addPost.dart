import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:helpdesk_shift/Screens/Home/navigation_view.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

myStyle(double fontSize,
    [Color color = Colors.white, FontWeight fw = FontWeight.w100]) {
  return GoogleFonts.roboto(
    fontSize: fontSize,
    fontWeight: fw,
    color: color,
  );
}

class _AddPostState extends State<AddPost> {
  CollectionReference postCollection;
  CollectionReference postCollectionInUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      postCollectionInUser =
          userCollection.doc(firebaseuser.uid).collection("posts");
      postCollection = FirebaseFirestore.instance.collection("posts");
    });
  }

  var firebaseuser = FirebaseAuth.instance.currentUser;
  // File imagePath;
  TextEditingController tweetController = TextEditingController();
  bool uploading = false;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userData');

  Reference postPictures = FirebaseStorage.instance.ref().child('postPictures');
  bool plCheck = false;
  bool oxyCheck = false;
  bool medicinecheck = false;
  String error = "";
  bool err = false;
  String countryValue;
  String stateValue;
  String cityValue;

  // pickImage(ImageSource imgSource) async {
  //   final image = await ImagePicker().getImage(source: imgSource);
  //   setState(() {
  //     imagePath = File(image.path);
  //   });
  //   Navigator.pop(context);
  // }

  // optionsDialog() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return SimpleDialog(
  //           children: [
  //             SimpleDialogOption(
  //               onPressed: () => pickImage(ImageSource.gallery),
  //               child: Text(
  //                 "Gallery",
  //                 style: myStyle(15, Colors.black),
  //               ),
  //             ),
  //             SimpleDialogOption(
  //               onPressed: () => pickImage(ImageSource.camera),
  //               child: Text(
  //                 "Camera",
  //                 style: myStyle(15, Colors.black),
  //               ),
  //             ),
  //             SimpleDialogOption(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text(
  //                 "Cancel",
  //                 style: myStyle(15, Colors.black),
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }

  // uploadImage(String id) async {

  //   UploadTask uploadTask = postPictures.child(id).putFile(imagePath);
  //   // TaskSnapshot taskSnapshot = uploadTask.snapshot;
  //   String downloadurl = await (await uploadTask).ref.getDownloadURL();
  //   return downloadurl;
  // }

  postTweet() async {
    if (tweetController.text == '' &&
        ((countryValue == "Choose Country" || countryValue == null) ||
            (stateValue == "Choose State" || stateValue == null) ||
            (cityValue == "Choose City" || cityValue == null))) {
      setState(() {
        err = true;
        error = "Enter Some Text or Select your City";
      });
      return;
    }
    setState(() {
      err = false;
      uploading = true;
    });

    DocumentSnapshot userdoc = await userCollection.doc(firebaseuser.uid).get();
    // var allDocs = await postCollection.get();
    // int length = allDocs.docs.length;
    var randomText = randomAlphaNumeric(10);
    //only tweet
    // if (tweetController.text != '' && imagePath == null) {
    if (tweetController.text != '') {
      var data = {
        'username': userdoc.data()['displayName'],
        'photoURL': userdoc.data()['photoURL'],
        'uid': firebaseuser.uid,
        'id': userdoc.data()['uid'] + "-" + randomText,
        'tweet': tweetController.text,
        'likes': [],
        'commentsCount': 0,
        'shares': 0,
        'type': 1,
        'time': DateTime.now(),
        'visible': false,
        'city': cityValue,
        'state': stateValue,
        'plasma': plCheck,
        'oxygen': oxyCheck,
        'medicine': medicinecheck,
      };
      postCollection.doc(userdoc.data()['uid'] + "-" + randomText).set(data);
      postCollectionInUser
          .doc(userdoc.data()['uid'] + "-" + randomText)
          .set(data);

       Navigator.of(context).maybePop();
    }
    //only image
    /*
    else if (tweetController.text == null ) {
      // String imageurl =
      //     await uploadImage(userdoc.data()['uid'] + "-" + randomText);
      postCollection.doc(userdoc.data()['uid'] + "-" + randomText).set({
        'username': userdoc.data()['name'],
        'photoURL': userdoc.data()['photoURL'],
        'uid': firebaseuser.uid,
        'id': userdoc.data()['uid'] + "-" + randomText,
        // 'image': imageurl,
        'likes': [],
        'commentsCount': 0,
        'shares': 0,
        'type': 2,
        'time': DateTime.now(),
        'visible': false,
        'city': cityValue,
        'state': stateValue,
        'plasma': plCheck,
        'oxygen': oxyCheck,
        'medicine': medicinecheck,
      });
      Navigator.pop(context);
    }
    //tweet and image
    else if (tweetController.text != '' ) {}
    // String imageurl =
    // await uploadImage(userdoc.data()['uid'] + "-" + randomText);
    postCollection.doc(userdoc.data()['uid'] + "-" + randomText).set({
      'username': userdoc.data()['name'],
      'photoURL': userdoc.data()['photoURL'],
      'uid': firebaseuser.uid,
      'id': userdoc.data()['uid'] + "-" + randomText,
      // 'image': imageurl,
      'tweet': tweetController.text,
      'likes': [],
      'commentsCount': 0,
      'city': cityValue,
      'state': stateValue,
      'plasma': plCheck,
      'oxygen': oxyCheck,
      'medicine': medicinecheck,
      'shares': 0,
      'type': 3,
      'time': DateTime.now(),
      'visible': false,
    });*/
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: err == true ? Colors.red : Colors.black,
        onPressed: () => postTweet(),
        label: Text(
          err != true ? "Upload Post" : error,
          style: myStyle(15, Colors.white, FontWeight.bold),
        ),
        icon: Icon(
          Icons.publish,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.close,
            size: 32,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Post",
          style: myStyle(20, Colors.white, FontWeight.bold),
        ),
        actions: [
          // InkWell(
          //     onTap: () => optionsDialog(),
          //     child: Icon(Icons.add_a_photo, size: 30))
        ],
      ),
      body: uploading == false
          ? Column(
              children: [
                SizedBox(height: 10),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: tweetController,
                    maxLines: 8,
                    style: myStyle(18, Colors.blue, FontWeight.bold),
                    decoration: InputDecoration.collapsed(
                      hintText:
                          "Please type here what do you need(Plasma, Oxygen, etc) from the donor, along with your contact details.",
                      hintStyle: myStyle(18, Colors.grey, FontWeight.bold),
                      fillColor: Colors.grey,
                      enabled: true,

                      // labelText: "Please type here what\ndo you need(Plasma, Oxygen, etc)\nfrom the donor,along with your contact details.",
                      // labelStyle: myStyle(25, Colors.grey, FontWeight.bold),
                    ),
                  ),
                ),
                // imagePath == null
                //     ? Container()
                //     : MediaQuery.of(context).viewInsets.bottom > 0
                //         ? Container()
                //         : Image(
                //             width: 400,
                //             height: 200,
                //             image: FileImage(imagePath),
                //           ),
                Column(
                  children: [
                    Divider(
                      color: Colors.grey,
                    ),
                    CheckboxListTile(
                      title: Text("Plasma"),
                      value: plCheck,
                      onChanged: (newValue) {
                        setState(() {
                          plCheck = newValue;
                          // print(plCheck);
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                    CheckboxListTile(
                      title: Text("Oxygen Cylinder"),
                      value: oxyCheck,
                      onChanged: (newValue) {
                        setState(() {
                          oxyCheck = newValue;
                          // print(plCheck);
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                    CheckboxListTile(
                      title: Text("Medicine"),
                      value: medicinecheck,
                      onChanged: (newValue) {
                        setState(() {
                          medicinecheck = newValue;
                          // print(plCheck);
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                    SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                          print(countryValue);
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                          print(stateValue);
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                          print(cityValue);
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "Uploading...",
                    style: myStyle(20, Colors.black),
                  )
                ],
              ),
            ),
    );
  }
}

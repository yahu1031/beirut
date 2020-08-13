import 'dart:io';
import 'package:beirut/Screens/profile.dart';
import 'package:beirut/styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beirut/styles.dart';

class EditProfile extends StatefulWidget {
  static const id = '/edit_profile';
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String address;
  String status;
  String name;
  String gender;
  int age;
  String phoneNumber;
  String message;

  StorageReference storageReference;
  File profileImg;

  final _auth = FirebaseAuth.instance;
  final fireStoreInstance = Firestore.instance;

  String userEmail;
  void getCurrentUserEmail() async {
    final user =
        await _auth.currentUser().then((value) => userEmail = value.email);
    print(userEmail);
  }

  Future _onPressed() async {
    getCurrentUserEmail();
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.uid);
    fireStoreInstance
        .collection("Users")
        .document(userEmail)
        .collection("profiles")
        .document(firebaseUser.uid)
        .setData({
      'status': status.toString(),
      'profile_pic_url': await saveImageOnFirebaseStorage(
          name, age, profileImg.path, profileImg),
      'name': name,
      'gender': gender,
      'age': age,
      'phoneNumber': phoneNumber,
      'message': message,
      'address': address,
    }).then((_) {
      print("success!");
    });
  }

  _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          child: FlatButton(
              onPressed: () {
                setState(() {
                  status = "Safe";
                });
              },
              child: Text("Safe")),
        ),
        PopupMenuItem(
          child: FlatButton(
              onPressed: () {
                setState(() {
                  status = "Emergency";
                });
              },
              child: Text("Emergency")),
        ),
      ],
      elevation: 8.0,
    );
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImg = image;
    });
  }

  Future<String> saveImageOnFirebaseStorage(
      String userName, int age, String imgPath, File file) async {
    //var file = profileImg.path;
    var filename = userName + age.toString();

    storageReference =
        await FirebaseStorage.instance.ref().child("images/$filename");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("$url");
    return url;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Color(0xFF232950),
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        padding: EdgeInsets.all(0),
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    IconButton(
                        padding: EdgeInsets.all(0),
                        color: Colors.white,
                        icon: Icon(Icons.notifications_none),
                        onPressed: () {})
                  ],
                ),
              ),
              Stack(
                children: [
                  FractionalTranslation(
                    translation: Offset(0.0, -0.4),
                    child: Align(
                      child: profileImg == null
                          ? CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey,
                              child: IconButton(
                                icon: Icon(Icons.input),
                                onPressed: () {
                                  getImage();
                                },
                              ),
                            )
                          : CircleAvatar(
                              radius: 55,
                              backgroundImage: Image.file(profileImg).image),
                      alignment: FractionalOffset(0.5, 0.0),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        border: Border.all(color: Colors.grey[800])),
                    width: 150,
                    height: 25,
                    child: GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          _showPopupMenu(details.globalPosition);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              if (status == "Emergency")
                                Text('Emergency')
                              else if (status == "Safe")
                                Text('Safe')
                              else
                                Text('EditStatus'),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 15, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NAME',
                      style: kOrangeText,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: 'Type Full Name here'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'GENDER',
                          style: kOrangeText,
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Text(
                          'AGE',
                          style: kOrangeText,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: 'Write Here'),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                age = int.parse(value);
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: 'Write Here'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'CONTACT DETAILS',
                      style: kOrangeText,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: 'Type Phone Number Here'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('LAST KNOW LOCATION', style: kOrangeText),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: screenWidth * 0.80,
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                address = value;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: 'Type your Address here'))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'MESSAGE',
                      style: kOrangeText,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[800])),
                        width: screenWidth * 0.80,
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              message = value;
                            });
                          },
                          maxLines: 5,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write The Message Here'),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      border: Border.all(color: Colors.grey[800])),
                  width: 100,
                  height: 35,
                  child: FlatButton(
                    onPressed: () async {
                      await _onPressed();
                      Navigator.pushReplacementNamed(context, Profile.id);
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 65,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.people),
                  onPressed: () {},
                  color: Colors.orange,
                ),
                IconButton(icon: Icon(Icons.add), onPressed: () {}),

                ///To:Do
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

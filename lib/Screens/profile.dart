import 'package:beirut/Screens/login_screen.dart';
import 'package:beirut/Screens/profile_page.dart';
import 'package:beirut/Screens/search_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'dart:io';
import 'package:beirut/styles.dart';

class Profile extends StatefulWidget {
  static const id = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final fireStoreInstance = Firestore.instance;

  @override
  void initState() {
    _onPressed();
    super.initState();
  }

  String name;
  String gender;
  int age;
  int phoneNumber;
  String message;

  File profileImg;

  final _auth = FirebaseAuth.instance;
  void logout() async {
    print('Signout');
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (_) => false);
  }

  String userEmail;
  void getCurrentUserEmail() async {
    final user =
    await _auth.currentUser().then((value) => userEmail = value.email);
    print(userEmail);
  }

  void _onPressed() async {
    getCurrentUserEmail();
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    fireStoreInstance
        .collection("Users")
        .document(userEmail)
        .collection("profiles")
        .document(firebaseUser.uid)
        .get()
        .then((value) {
      Map data = value.data;
      print(data);
      name = data['name'];
    });
  }



  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:  fireStoreInstance.collection("Users").
                  document(userEmail).collection("profiles").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child:  CircularProgressIndicator(),
                      );
                    case ConnectionState.none:
                      return Center(
                        child: Text('Create Your Profile', style: TextStyle(fontSize: 30, color: Colors.orange)),
                      );
                    default:
                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            File file = new File(snapshot.data.documents[index].data['profile_pic']);
                            print(file);
                            return Container(
                              height: screenHeight ,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.indigo[800],
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
                                                logout();
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
                                            child: CircleAvatar(
                                              radius: 55.0,
                                              backgroundImage: Image.file(file).image
                                         ),
                                            alignment: FractionalOffset(0.5, 0.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Text(snapshot.data.documents[index].data['name'],
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('خليل',
                                              style: TextStyle(
                                                  color: Colors.teal, fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              border: Border.all(color: Colors.grey[800]),
                                            ),
                                            width: screenWidth * 0.50,
                                            height: 30,
                                            child: Center(child: Text('Safe')),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.call,
                                                color: Colors.teal,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  snapshot.data.documents[index].data['phoneNumber'].toString(),
                                                style: TextStyle(
                                                    color: Colors.teal, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Row(
                                            children: [
                                              Text('CONTACT', style: kOrangeText),
                                              SizedBox(
                                                width: 85,
                                              ),
                                              Text(
                                                'GENDER',
                                                style: kOrangeText,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 80,
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Icon(
                                                      Icons.call,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(Icons.tag_faces),

                                                    ///To:Do Add facebook image
                                                    Icon(Icons.tag_faces),

                                                    ///To:Do Add instagram image
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  textBaseline: TextBaseline.ideographic,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(snapshot.data.documents[index].data['phoneNumber'].toString()),
                                                    Text('@user_name'),
                                                    Text('@user_name'),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(snapshot.data.documents[index].data['gender']),
                                                    Text('AGE', style: kOrangeText,),
                                                    Text(snapshot.data.documents[index].data['age'].toString())],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('LAST KNOW LOCATION', style: kOrangeText),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              width: screenWidth * 0.80,
                                              child: Text(
                                                  'NO 123, ABC Road El Houston, Lebanon, check ok ')),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text('MESSAGE', style: kOrangeText),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey[800])),
                                            width: screenWidth * 0.80,
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                                snapshot.data.documents[index].data['message']
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 100,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                            );
                          });
                  }
                }
              )
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
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, ProfilePage.id);
                  },
                  color: Colors.orange,
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {},
                ),

                ///To:Do
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, SearchUserPage.id);
                  },
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

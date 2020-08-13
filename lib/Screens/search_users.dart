import 'package:beirut/Screens/login_screen.dart';
import 'package:beirut/Screens/profile.dart';
import 'package:beirut/Screens/profile_page.dart';
import 'package:beirut/profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUserPage extends StatefulWidget {
  static const id = '/searchuser';
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  List<Widget> profileList = [
    ProfileCard(),
    ProfileCard(),
  ];

  final _auth = FirebaseAuth.instance;
  void logout() async {
    print('Signout');
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 190.0,
              color: Colors.red.shade900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            logout();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 40.0,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.notifications_none,
                          size: 40.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Search Users",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        hintText: "Enter Your Name",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: profileList,
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
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ProfilePage.id);
                },
                color: Colors.orange,
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Profile.id);
                },
              ),

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
    );
  }
}

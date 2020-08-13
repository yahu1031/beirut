import 'package:beirut/ProfileMode.dart';
import 'package:beirut/Screens/edit_profile.dart';
import 'package:beirut/Screens/profile.dart';
import 'package:beirut/Screens/search_users.dart';
import 'package:beirut/profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:beirut/Components/Services/auth_services.dart';
import 'package:beirut/Screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  static const id = '/profilepage';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Widget> profileList = [];

  final firestore = Firestore.instance;
  final List<ProfileModel> FinalProfileModelList = [];

  Future<Widget> getProfiles() async {
    print("getpro");
    List emailList = await firestore
        .collection("User")
        .getDocuments()
        .then((value) => value.documents);
    print(emailList);
    for (int i = 0; i < emailList.length; i++) {
      print(emailList[i].documentID.toString());
      Firestore.instance
          .collection("User")
          .document(emailList[i].documentID.toString())
          .collection("profiles")
          .snapshots()
          .listen(createListofProfiles);
    }
  }

  createListofProfiles(QuerySnapshot snapshot) async {
    print("hello");
    var docs = snapshot.documents;
    for (var Doc in docs) {
      FinalProfileModelList.add(ProfileModel.fromFireStore(Doc));
    }
    createProfileCardsList();
  }

  createProfileCardsList() {
    for (var profileModel in FinalProfileModelList) {
      profileList.add(
        ProfileCard(
          profileModel: profileModel,
        ),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _auth = AuthServices();
    void logout() async {
      print('Signout');
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (_) => false);
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
        backgroundColor: Color(0xFF232950),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            logout();
          },
        ),
        title: Text(
          "Profile Page",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: profileList,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, EditProfile.id);
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Color(0xFF232950),
      ),
    );
  }
}

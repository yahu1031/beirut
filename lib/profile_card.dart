import 'package:beirut/ProfileMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  ProfileModel profileModel;

  ProfileCard({this.profileModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Khalid Ahmed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF195E4B),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "STATUS:",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("Safe"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "GENDER:",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text("Male"),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "AGE:",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text("26"),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Text(
                    "Khalid Ahmed",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF195E4B),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                  ),
                  Text(
                    "LAST KNOWN LOCATION",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                      color: Colors.teal.shade700,
                    ),
                  ),
                  Icon(
                    Icons.call,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "You: message",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Divider(
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileModel {
  String name;
  String phone_number;
  String status;
  //String instagram;
  String message;
  String address;
  String gender;
  int age;
  String imageURL;

  ProfileModel({
    this.name = "unknown",
    this.phone_number = "unknown",
    this.status = "unknown",
    //   this.instagram = "unknown",
    this.message = "unknown",
    this.address = "unknown",
    this.gender = "unknown",
    this.age,
    this.imageURL,
  });

  factory ProfileModel.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return ProfileModel(
      name: data['name'],
      phone_number: data['phoneNumber'],
      status: data['status'],
//      instagram: data['instagram'],
      message: data['message'],
      address: data['address'],
      gender: data['gender'],
      age: data['age'],
      imageURL: data['profile_pic_url'],
    );
  }
}

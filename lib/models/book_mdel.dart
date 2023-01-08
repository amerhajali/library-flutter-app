import 'package:cloud_firestore/cloud_firestore.dart';

class CategModel {
  String? id;
  String? name;

  CategModel(this.id, this.name);
}

class BookModel {
  String? id;
  String? name;
  String? categ;
  double? cost;
  int? quantity;
  int? fav;
  bool? availability;
  String? image;
  Timestamp? time;

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categ = json['categ'];
    cost = json['cost'];
    image = json['image'];
    quantity = json['quantity'];
    fav = json['fav'];
    availability = json['availability'];
    time = json['time'];
  }
}

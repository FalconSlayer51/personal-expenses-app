import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personalexpenseapp/homepage.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class Transactions {
  String title;
  String id;
  double amount;
  DateTime time;

  Transactions({
    required this.title,
    required this.amount,
    required this.time,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'amount': amount,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      title: map['title'] ?? '',
      id: map['id'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }
  
}

 List<Transactions> transaction = [];

  List<Transactions> get recentTransaction {
    return transaction.where(
      (element) {
        return element.time.isAfter(
          DateTime.now().subtract(
            const Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

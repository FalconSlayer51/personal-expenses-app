import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypto_flutter/encrypto_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personalexpenseapp/models/transaction.dart';

import '../homepage.dart';

class TransactionList extends StatefulWidget {
  final Function deleteTx;
  const TransactionList({
    Key? key,
    required this.deleteTx,
  }) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Encrypto encrypto = Encrypto(Encrypto.RSA);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(encrypto.sterilizePublicKey());
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(10),
      height: height / 1.8,
      child: StreamBuilder(
          stream: firestore
              .collection('users')
              .doc(uid)
              .collection('transactions')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  var transactions = snapshot.data!.docs[index];
                  return Container(
                    height: 75,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: ListTile(
                        leading: Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "₹${transactions['amount'].toStringAsFixed(2)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          transactions['title'],
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          DateFormat.yMMMEd()
                              .format(transactions['time'].toDate())
                              .toString(),
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        trailing: IconButton(
                            onPressed: () =>
                                widget.deleteTx(transactions['id']),
                            icon: Icon(Icons.delete, color: Colors.red)),
                      ),
                    ),
                  );
                });
          }), //remove
    );
  }
}

import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:encrypto_flutter/encrypto_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personalexpenseapp/models/transaction.dart';
import 'package:personalexpenseapp/screens/chart.dart';
import 'package:personalexpenseapp/screens/new_transaction.dart';
import 'package:personalexpenseapp/screens/profile.dart';
import 'package:personalexpenseapp/screens/transactionlist..dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Encrypto encrypto = Encrypto(Encrypto
      .RSA); // or Encrypto(Encrypto.RSA, bitLength: 1024) or Encrypto(Encrypto.RSA, pw: 'foofoo78')
//this generates public and private keys for e2ee or initiates DES encryption
  int index = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final items = <Widget>[Icon(Icons.home), Icon(Icons.person)];
  fetchData() async {
    var records = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('transactions')
        .get();

    var recs = records.docs
        .map(
          (e) => Transactions(
              title: encrypto.decrypt(e['title']),
              amount: e['amount'],
              time: e['time'].toDate(),
              id: e['id']),
        )
        .toList();
    setState(() {
      transaction = recs;
    });
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) async {
    //final base64PublicKey = encrypto.getPublicKeyString();
    String base64encrypted = encrypto.encrypt(txTitle,
        publicKey:
            Encrypto.desterilizePublicKey(encrypto.sterilizePublicKey()));
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('transactions')
        .doc(DateTime.now().toString().substring(0, 19))
        .set({
      'title': base64encrypted,
      'amount': txAmount,
      'time': chosenDate,
      'id': DateTime.now().toString().substring(0, 19),
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(
                addtx: _addNewTransaction,
              ));
        });
    //Navigator.of(context).pop();
  }

  deletTrasnaction(String id) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transactions')
        .doc(id)
        .delete();

    transaction.removeWhere((element) => element.id == id);
  }

  void initiealizeNotifications() async {
    var fcm = FirebaseMessaging.instance;
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String? token = await FirebaseMessaging.instance.getToken();
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('tokens')
        .doc(token)
        .set({'createdAt': DateTime.now(), 'token': token});

    var listen = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) print('Got a message whilst in the foreground!');
      if (kDebugMode) print('Message data: ${message.data}');

      if (message.notification != null) {
        if (kDebugMode)
          print(
              'Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(encrypto.sterilizePublicKey());
    initiealizeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Expenses',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Curves.easeIn,
        items: items,
        height: 60,
        backgroundColor: Colors.white10,
        color: Colors.blue,
        onTap: (index) => setState(() {
          this.index = index;
        }),
      ),
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        onPressed: () => startAddNewTransaction(context),
        child: Icon(
          Icons.add,
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: index == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Chart(
                      recentTransaction: recentTransaction,
                      chartrender: fetchData),
                  TransactionList(deleteTx: deletTrasnaction),
                ],
              ),
            )
          : Profile(),
    );
  }
}

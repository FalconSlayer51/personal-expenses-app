import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(auth.currentUser!.photoURL!),
              radius: 50,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              auth.currentUser!.displayName!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "📧  :  " + auth.currentUser!.email!,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 130,
              child: ElevatedButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.of(context).pushReplacementNamed('/loginpage');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout),
                    // ignore: unnecessary_const
                    const SizedBox(
                      width: 20,
                    ),
                    Text('Logout')
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

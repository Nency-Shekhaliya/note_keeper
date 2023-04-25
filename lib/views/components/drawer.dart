import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_keeper/helpers/firebase_auth_helper.dart';
import 'package:note_keeper/views/screens/global.dart';

class My_Drawer extends StatefulWidget {
  final User user;

  const My_Drawer({Key? key, required this.user}) : super(key: key);

  @override
  State<My_Drawer> createState() => _My_DrawerState();
}

class _My_DrawerState extends State<My_Drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: Center(
                child: (widget.user.isAnonymous)
                    ? Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                      )
                    : CircleAvatar(
                        radius: 60,
                        foregroundImage: (widget.user.photoURL == null)
                            ? null
                            : NetworkImage(widget.user.photoURL as String),
                      ),
              ),
            ),
            (widget.user.isAnonymous)
                ? const Text(
                    "User Is Anonymous",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    "${Global.username}",
                    style: GoogleFonts.alegreya(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
            (widget.user.isAnonymous)
                ? Container()
                : Text(
                    "${widget.user.email}",
                    style: GoogleFonts.alegreya(
                      fontSize: 15,
                    ),
                  ),
            GestureDetector(
              onTap: () async {
                await FirebasAuthhelper.firebasAuthhelper.signout();
                Navigator.pushNamedAndRemoveUntil(
                    context, 'Welcome_page', (route) => false);
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.centerLeft,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sign Out",
                      style: GoogleFonts.alegreya(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Icon(Icons.logout)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

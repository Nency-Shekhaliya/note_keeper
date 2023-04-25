import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_keeper/helpers/firebase_auth_helper.dart';

class Welcome_page extends StatefulWidget {
  const Welcome_page({Key? key}) : super(key: key);

  @override
  State<Welcome_page> createState() => _Welcome_pageState();
}

class _Welcome_pageState extends State<Welcome_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 50, top: 50),
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome...",
                style: GoogleFonts.alegreya(
                    fontWeight: FontWeight.bold, fontSize: 35),
              )),
          Container(
            height: 200,
            width: 360,
            decoration: BoxDecoration(
                color: Colors.amber.shade300,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            "login_page",
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.amber.shade200,
                              border:
                                  Border.all(color: Colors.black, width: 1.2),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed("Signin_page");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.amber.shade200,
                              border:
                                  Border.all(color: Colors.black, width: 1.2),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> data = await FirebasAuthhelper
                        .firebasAuthhelper
                        .signinwithgoogle();
                    if (data['user'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login Successfully..."),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.of(context)
                          .pushReplacementNamed('Home_Page', arguments: data);
                    } else if (data['msg'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(data['msg']),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login Failed..."),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Signin with Google",
                    style: GoogleFonts.alegreya(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueGrey),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

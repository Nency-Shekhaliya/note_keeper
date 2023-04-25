import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_keeper/views/screens/global.dart';

import '../../helpers/firebase_auth_helper.dart';

class Signin_page extends StatefulWidget {
  const Signin_page({
    Key? key,
  }) : super(key: key);

  @override
  State<Signin_page> createState() => _Signin_pageState();
}

class _Signin_pageState extends State<Signin_page> {
  GlobalKey<FormState> siginkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.shade100,
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              CustomPaint(
                foregroundPainter: Mypainter(),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  color: Colors.amber.shade400,
                  height: 270,
                  width: 360,
                  child: Text(
                    "Sign In",
                    style: GoogleFonts.alegreya(
                        fontSize: 35,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Form(
                  key: siginkey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(c
                          "Email",
                          style: GoogleFonts.alegreya(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onSaved: (val) {
                            Global.email = val;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter Email address";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.2)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              label: Text(
                                "Enter Email address",
                                style: GoogleFonts.alegreya(
                                    fontSize: 15, color: Colors.grey.shade700),
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Password",
                          style: GoogleFonts.alegreya(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          onSaved: (val) {
                            Global.password = val;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter password";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.2)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              label: Text(
                                "Enter Password",
                                style: GoogleFonts.alegreya(
                                    fontSize: 15, color: Colors.grey.shade700),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (siginkey.currentState!.validate()) {
                              siginkey.currentState!.save();
                              Map<String, dynamic> data =
                                  await FirebasAuthhelper.firebasAuthhelper
                                      .sigin(
                                          email: "${Global.email}",
                                          Password: "${Global.password}");
                              if (data['user'] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                        content: Text("Sign In Successfully")));
                                Navigator.of(context).pushReplacementNamed(
                                    'Home_Page',
                                    arguments: data);
                              } else if (data['msg'] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("${data['msg']}")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Sign In Failed")));
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            height: 50,
                            width: 340,
                            decoration: BoxDecoration(
                                color: Colors.amber.shade300,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.alegreya(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}

class Mypainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint();
    brush.style = PaintingStyle.fill;
    brush.color = Colors.amber.shade100;
    Offset p1 = const Offset(0, 0);
    Offset p2 = Offset(size.width, size.height);
    Offset p3 = Offset(0, size.height);
    Path path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.73,
        size.width * 0.35, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.80, size.height * 0.85,
        size.width * 0.81, size.height * 0.45);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.10, size.width, 0);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, brush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

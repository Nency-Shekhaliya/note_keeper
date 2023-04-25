import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_keeper/helpers/firebase_auth_helper.dart';
import 'package:note_keeper/views/screens/global.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key? key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  GlobalKey<FormState> signupkey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

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
                    "Create Account",
                    style: GoogleFonts.alegreya(
                        fontSize: 35,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Form(
                  key: signupkey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "User Name",
                          style: GoogleFonts.alegreya(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: usernamecontroller,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onSaved: (val) {
                            Global.username = val;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter user name";
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
                                "Enter Name",
                                style: GoogleFonts.alegreya(
                                    fontSize: 15, color: Colors.grey.shade700),
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Email",
                          style: GoogleFonts.alegreya(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: emailcontroller,
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
                          controller: passwordcontroller,
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
                            if (signupkey.currentState!.validate()) {
                              signupkey.currentState!.save();

                              Map<String, dynamic> data =
                                  await FirebasAuthhelper.firebasAuthhelper
                                      .signup(
                                          username: usernamecontroller.text,
                                          email: emailcontroller.text,
                                          Password: passwordcontroller.text);
                              if (data['user'] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Sign Up Successfully..."),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'Signin_page', (route) => false);
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
                              usernamecontroller.clear();
                              emailcontroller.clear();
                              passwordcontroller.clear();
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
                              "Sign Up",
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

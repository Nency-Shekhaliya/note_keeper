import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_keeper/helpers/Firebasestore_helper.dart';
import 'package:note_keeper/views/components/drawer.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  String? note;
  String? title;
  GlobalKey<FormState> insertkey = GlobalKey<FormState>();
  GlobalKey<FormState> Updatekey = GlobalKey<FormState>();
  TextEditingController notescontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Notes",
          style:
              GoogleFonts.alegreya(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        backgroundColor: Colors.amber.shade300,
        actions: [
          Transform.scale(
            scale: 0.8,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                insertdata();
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 15,
              ),
              label: Text(
                "Add Note",
                style: GoogleFonts.alegreya(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      drawer: My_Drawer(user: data['user']),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
            if (data == null) {
              return const Center(
                child: Text("No data Available"),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> alldocument =
                  data.docs;
              return ListView.builder(
                itemCount: alldocument.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.amber.shade50,
                    elevation: 5,
                    margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: ListTile(
                      style: ListTileStyle.list,
                      leading: Text(
                        "${alldocument[index].id}",
                        style: GoogleFonts.alegreya(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        "${alldocument[index].data()['title']}",
                        style: GoogleFonts.alegreya(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${alldocument[index].data()['Notes']}",
                        style: GoogleFonts.alegreya(
                          fontSize: 14,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                updatedata(
                                    id: alldocument[index].id,
                                    data: alldocument[index]);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 15,
                              ),
                              label: Text(
                                "Edit",
                                style: GoogleFonts.alegreya(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await Firestorehelper.firestorehelper
                                    .deleterecored(id: alldocument[index].id);
                              },
                              icon: const Icon(
                                Icons.delete_outlined,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  insertdata() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 10,
          title: Text(
            "Note",
            style: GoogleFonts.alegreya(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                  key: insertkey,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Title :",
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.bold),
                          )),
                      TextFormField(
                        controller: titlecontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) {
                          title = val;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter title";
                          } else {
                            return null;
                          }
                        },
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Write a note :",
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: notescontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onSaved: (val) {
                          note = val;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter note";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 3,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ],
                  ))
            ],
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    note = null;
                    title = null;
                  });
                  notescontroller.clear();
                  titlecontroller.clear();
                  Navigator.pop(context);
                },
                child: const Text("Cancle")),
            OutlinedButton(
                onPressed: () async {
                  if (insertkey.currentState!.validate()) {
                    insertkey.currentState!.save();
                    Map<String, dynamic> record = {
                      "Notes": notescontroller.text,
                      "title": titlecontroller.text,
                    };
                    await Firestorehelper.firestorehelper
                        .insertrecord(data: record);

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        content: Text("Note add successfully")));
                    Navigator.pop(context);

                    setState(() {
                      note = null;
                      title = null;
                    });
                    notescontroller.clear();
                    titlecontroller.clear();
                  }
                },
                child: const Text("Add")),
          ],
        );
      },
    );
  }

  updatedata(
      {required String id,
      required QueryDocumentSnapshot<Map<String, dynamic>> data}) {
    Map<String, dynamic> myData = data.data();

    titlecontroller.text = myData['title'];
    notescontroller.text = myData['Notes'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 10,
          title: Text(
            "Note",
            style: GoogleFonts.alegreya(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                  key: Updatekey,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Title :",
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.bold),
                          )),
                      TextFormField(
                        controller: titlecontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) {
                          title = val;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter title";
                          } else {
                            return null;
                          }
                        },
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Write a note :",
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: notescontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onSaved: (val) {
                          note = val;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter note";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 3,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ],
                  ))
            ],
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    note = null;
                    title = null;
                  });
                  notescontroller.clear();
                  titlecontroller.clear();
                  Navigator.pop(context);
                },
                child: const Text("Cancle")),
            OutlinedButton(
                onPressed: () async {
                  if (Updatekey.currentState!.validate()) {
                    Updatekey.currentState!.save();
                    Map<String, dynamic> updaterecord = {
                      "Notes": note,
                      "title": title,
                    };
                    await Firestorehelper.firestorehelper
                        .updaterecored(data: updaterecord, id: id);

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        content: Text("Note Updated successfully")));
                    Navigator.pop(context);

                    setState(() {
                      note = null;
                      title = null;
                    });
                    notescontroller.clear();
                    titlecontroller.clear();
                  }
                },
                child: const Text("Update")),
          ],
        );
      },
    );
  }
}

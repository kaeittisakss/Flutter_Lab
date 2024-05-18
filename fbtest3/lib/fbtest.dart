import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class fbtest extends StatefulWidget {
  const fbtest({super.key});

  @override
  State<fbtest> createState() => _fbtestState();
}

class _fbtestState extends State<fbtest> {
  
  void do_del(String id, String name) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference user = db.collection('userdata');

    if (id.contains('job')) {
      try {
        await user.doc(id).delete();
        alert_complete('Success', 'Delete successful');
        setState(() {
          print('deleted');
        });
      } catch (e) {
        print('Error updating document: $e');
        alert_complete('Error', 'Failed to delete');
      }
    } else {
      alert_complete('Error', 'ไม่สามารถลบข้อมูลได้ที่เพิ่มมาจากภายนอก');
    }

    setState(() {
      print('deleted');
    });
  }

  void do_insert(String name, String job) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference user = db.collection('userdata');
    var customkey = 'job' + Random().nextInt(100000000).toString();
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'job': job,
    };
    try {
      await user.doc(customkey).set(data);
      setState(() {
        print('Add');
        alert_complete('Success', 'Insert successful');
      });
    } catch (e) {
      print('Error updating document: $e');
      alert_complete('Error', 'Failed to add data');
    }
    setState(() {
      print('inserted');
    });
  }

  void do_edit(String Id, String name, String job) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference user = db.collection('userdata');
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'job': job,
    };
    try {
      await user.doc(Id).update(data);
      setState(() {
        print('edited');
        alert_complete('Success', 'Update successful');
      });
    } catch (e) {
      print('Error updating document: $e');
      alert_complete('Error', 'Failed to update');
    }
    setState(() {
      print('edited');
    });
  }

  void alert_complete(String title, String conn) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(title, style: TextStyle(color: Colors.white)),
          content: Text(conn, style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cloud Firestore Example',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('userdata').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 26, 25, 25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                        title: snapshot.data!.docs[index]['name'] != null
                            ? Text(snapshot.data!.docs[index]['name'],
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                            : Text('No data',
                                style: TextStyle(color: Colors.white)),
                        subtitle: snapshot.data!.docs[index]['job'] != null
                            ? Text(
                                snapshot.data!.docs[index]['job'],
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[300]),
                              )
                            : Text(''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                do_alert2(
                                    snapshot.data!.docs[index].id,
                                    snapshot.data!.docs[index]['name'],
                                    snapshot.data!.docs[index]['job']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // do_del(snapshot.data!.docs[index].id);
                                alertdel(snapshot.data!.docs[index].id,
                                    snapshot.data!.docs[index]['name']);
                              },
                            ),
                          ],
                        )),
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          do_alert();
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void alertdel(String id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Delete Data', style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to delete this data?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                do_del(id, name);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void do_alert() {
    TextEditingController nameController = TextEditingController();
    TextEditingController jobController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Add Data', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: jobController,
                decoration: InputDecoration(
                    labelText: 'Job',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                do_insert(nameController.text, jobController.text);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void do_alert2(String Id, String name, String job) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController jobController = TextEditingController(text: job);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Edit Data', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: jobController,
                decoration: InputDecoration(
                    labelText: 'Job',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                alerteidt(Id, nameController.text, jobController.text);
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void alerteidt(String Id, String name, String job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Edit Data', style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to edit this data?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                do_edit(Id, name, job);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}

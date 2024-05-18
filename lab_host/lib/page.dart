import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Hostpage extends StatefulWidget {
  const Hostpage({super.key});

  @override
  State<Hostpage> createState() => _HostpageState();
}

class _HostpageState extends State<Hostpage> {
  List<dynamic> Userdata = [];
  TextEditingController nameControll = TextEditingController();

  Future<void> fetch_data() async {
    Userdata = [];
    var url = Uri.parse("http://10.0.2.2:8000/user");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      // return data;
      setState(() {
        Userdata = data;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> deleteUser(int index) async {
    var url = Uri.parse("http://10.0.2.2:8000/user/${index}");
    var response = await http.delete(url);
    if (response.statusCode == 200) {
      fetch_data();
    } else {
      throw Exception('Failed to delete user');
    }
  }

  void manageUser({required String operation, int? index, String? name}) async {
    nameControll.text = name ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$operation User"),
          content: TextField(
            controller: nameControll,
            decoration: InputDecoration(
              labelText: "User Name",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                print(nameControll.text);
                var url = Uri.parse(
                    "http://10.0.2.2:8000/user${index != null ? '/$index' : ''}");
                var response =
                    await (operation == 'Insert' ? http.post : http.put)(
                  url,
                  body: jsonEncode({'name': nameControll.text}),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                );
                if (response.statusCode == 200) {
                  fetch_data();
                  nameControll.clear();
                  Navigator.pop(context);
                } else {
                  throw Exception('Failed to $operation user');
                }
              },
              child: Text(operation),
            ),
          ],
        );
      },
    );
  }

  Widget UserList() {
    return ListView.builder(
      itemCount: Userdata.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('${Userdata[index][1]}'),
          subtitle: Text('ID: ${Userdata[index][0]}'),
          leading: Text(
            "${index + 1}",
            style: TextStyle(
              fontSize: 20,
              color: Colors.deepPurple,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.orange,
                ),
                onPressed: () => manageUser(
                  operation: "Update",
                  index: Userdata[index][0],
                  name: Userdata[index][1],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => deleteUser(Userdata[index][0]),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Host"),
        backgroundColor: Colors.blueGrey, // Futuristic color
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetch_data,
              child: Text("FETCH DATA"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.indigoAccent, // Text color
              ),
            ),
            Userdata.isNotEmpty
                ? Expanded(child: UserList()) // Assuming UserList is defined elsewhere
                : Text("Awaiting Data..."),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => manageUser(operation: "Insert"),
        child: const Icon(Icons.computer), // AI-related icon
        backgroundColor: Colors.purpleAccent, // Enhanced thematic color
      ),
    );
  }
}

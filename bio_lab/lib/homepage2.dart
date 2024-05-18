import 'package:bio_lab/bio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  void _minusCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) - 1;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, 
              children: <Widget>[
                ElevatedButton.icon(
                  icon: Icon(Icons.remove,
                      color: Colors.white), 
                  label: Text("1"),
                  onPressed: () {
                    _minusCounter();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 255, 184, 31)), 
                    foregroundColor: MaterialStateProperty.all(
                        Colors.white), 
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.white), 
                  label: Text("1"),
                  onPressed: () {
                    _incrementCounter();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 30, 93, 127)), 
                    foregroundColor: MaterialStateProperty.all(
                        Colors.white), 
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Logout Confirmation'),
                content: Text('Are you sure you want to logout?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                  ),
                  TextButton(
                    child: Text('Logout'),
                    onPressed: () {
                      logout();
                    },
                  ),
                ],
              );
            },
          );
        },
        label: Text('Logout'), // ข้อความบนปุ่ม
        icon: Icon(Icons.logout), // ไอคอนบนปุ่ม
        backgroundColor: const Color.fromARGB(255, 136, 32, 0),
        foregroundColor: Colors.white,
      ),
    );
  }

  logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyBio()));
  }
}

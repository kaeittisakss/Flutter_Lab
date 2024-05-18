import 'package:flutter/material.dart';
import 'package:crud/book.dart';
import 'package:crud/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> Books = [];
  late Dbhelper db;
  List<Book> books = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  void LoadBooksFromDB() async {
    Database? db = await Dbhelper.instance.database;
    List<Map<String, dynamic>> books = await db!.query(Dbhelper.tablename);
    setState(() {
      Books = books;
    });
  }

  Future<void> insertBook(String name, int price) async {
    Book book = Book(name: name, price: price);
    Dbhelper db = Dbhelper.instance;
    await db.insert(book.tojson());
    List<Map<String, dynamic>> books = await db.queryall();
    print(books);
    setState(() {
      Books = books;
    });
  }

  Future<void> updateBook(int id, String name, int price) async {
    print("${id} , ${name} , ${price}");
    Dbhelper db = Dbhelper.instance;
    Book book = Book(id: id, name: name, price: price);
    await db.update(book.tojson());
    List<Map<String, dynamic>> books = await db.queryall();
    setState(() {
      Books = books;
      nameController.text = "";
      priceController.text = "";
    });
  }

  Future<void> deleteBook(int id) async {
    Dbhelper db = Dbhelper.instance;
    await db.delete(id);
    List<Map<String, dynamic>> books = await db.queryall();
    setState(() {
      Books = books;
    });
  }

  void showAlertEditBook(String name, int price, int id) {
  setState(() {
    nameController.text = name;
    priceController.text = price.toString();
  });
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
            
          "Edit Book",
            style: TextStyle(color: Colors.greenAccent),// เปลี่ยนสีของข้อความในหัวข้อเป็นสีน้ำเงิน
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: const Color.fromARGB(255, 249, 249, 249)), // เปลี่ยนสีของตัวอักษรในช่องกรอกเป็นสีน้ำเงิน
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)), // เปลี่ยนสีของตัวอักษร Label เป็นสีน้ำเงิน
              ),
            ),
            TextField(
              controller: priceController,
              style: TextStyle(color: const Color.fromARGB(255, 254, 254, 254)), // เปลี่ยนสีของตัวอักษรในช่องกรอกเป็นสีน้ำเงิน
              decoration: InputDecoration(
                labelText: "Price",
                labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)), // เปลี่ยนสีของตัวอักษร Label เป็นสีน้ำเงิน
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              updateText();
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.red), // เปลี่ยนสีของข้อความปุ่ม Cancel เป็นสีแดง
            ),
          ),
          TextButton(
            onPressed: () {
              updateBook(
                id, 
                nameController.text, 
                int.parse(priceController.text)
              );
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.green), // เปลี่ยนสีของข้อความปุ่ม Save เป็นสีเขียว
            ),
          ),
        ],
      );
    },
  );
}


  void updateText() {
    setState(() {
      nameController.text = "";
      priceController.text = "";
    });
  }

  void showAlertAddBook() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Add Book",
          style: TextStyle(color: Colors.greenAccent
),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            TextField(
              controller: priceController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Price",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              updateText();
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: const Color.fromARGB(255, 175, 7, 7)),
            ),
          ),
          TextButton(
            onPressed: () {
              insertBook(
                nameController.text,
                int.parse(priceController.text),
              );
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Color.fromARGB(255, 5, 196, 20)),
            ),
          ),
        ],
      );
    },
  );
}


  @override
  void initState() {
    super.initState();
    db = Dbhelper.instance;
    LoadBooksFromDB();
  }

  Widget buildCard() {
  return Column(
    children: Books.asMap().entries.map(
      (entry) {
        int index = entry.key;
        Map<String, dynamic> book = entry.value;
        return Card(
          // Set padding
          color: Color.fromARGB(255, 32, 32, 32), // เปลี่ยนสีพื้นหลังของการ์ดเป็นสีที่เกี่ยวข้องกับสีที่ใช้ในธีมของอนาคต
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Color.fromARGB(255, 148, 149, 150),
              width: 2,
            ),
          ),
          child: ListTile(
            leading: const Icon(Icons.check_circle_outline, color: Colors.white), // เปลี่ยน icon เป็นหุ่นยนต์ ซึ่งเป็นสัญลักษณ์ของเทคโนโลยีและอนาคต AI
            //leading: const Icon(Icons.book, color: Colors.white),
            trailing: Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showAlertEditBook(
                          book["name"], book["price"], book["id"]);
                    },
                    icon: const Icon(Icons.edit_document, color: Colors.cyan), // เปลี่ยนสีไอคอนเพื่อให้เหมาะสมกับลักษณะของโลกอนาคต AI
                  ),
                  IconButton(
                    onPressed: () {
                      deleteBook(book["id"]);
                    },
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.redAccent, // เปลี่ยนสีไอคอนเพื่อให้เหมาะสมกับลักษณะของโลกอนาคต AI
                    ),
                  ),
                ],
              ),
            ),
            title: Text("${index + 1} ${book["name"]}", style: TextStyle(color: Colors.white)), // ปรับสีของข้อความให้เป็นสีขาว
            subtitle: Text(
              book["price"].toString(),
              style: TextStyle(color: Colors.grey), // เปลี่ยนสีของข้อความราคาเป็นสีเทา
            ),
          ),
        );
      },
    ).toList(),
  );
}



  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('book'),
      backgroundColor: Color.fromARGB(255, 18, 32, 52),
      foregroundColor: Colors.white,
    ),
    body: Container(
  width: double.infinity,
  color: Color.fromARGB(255, 13, 48, 64), // Set the background color here
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Color.fromARGB(255, 7, 45, 86),
              side: const BorderSide(
                color: Colors.greenAccent,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: showAlertAddBook,
            child: Text("Add"),
          ),
        ],
      ),
      Expanded(
        child: SingleChildScrollView(
          child: buildCard(),
        ),
      )
    ],
  ),
),

  );
}


}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:yuna/Model/Quiz.dart';

class Quizpage extends StatefulWidget {
  const Quizpage({super.key});

  @override
  State<Quizpage> createState() => _QuizpageState();
}

class _QuizpageState extends State<Quizpage> {
  bool checkSend = false;
  List SelectChoice = List.filled(3, 1);
  late List<QuizModel> _quizs = [];
  List GroupValue = [];
  int Score = 0;
  List shuffle(List items) {
    var random = Random();

    for (var i = items.length - 1; i >= 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = items[i];

      items[i] = items[n];

      items[n] = temp;
      for (var j = 0; j < items[i].choices.length; j++) {
        var m = random.nextInt(j + 1);
        var temp2 = items[i].choices[j];
        items[i].choices[j] = items[i].choices[m];
        items[i].choices[m] = temp2;
      }
    }
    for (var i = 0; i < items.length; i++) {
      GroupValue.add(items[i].choices[0].id);
    }
    print(GroupValue);
    return items;
  }

  void shuffleQuiz() {
    var random = Random();
    for (var i = _quizs.length - 1; i >= 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = _quizs[i];

      _quizs[i] = _quizs[n];

      _quizs[n] = temp;
    }
    GroupValue.clear();
    for (var i = 0; i < _quizs.length; i++) {
      GroupValue.add(_quizs[i].choices[0].id);
    }
    setState(() {
      _quizs = _quizs;
      GroupValue = GroupValue;
      checkSend = false;
    });
  }

  void shuffleChoice() {
    var random = Random();
    for (var i = _quizs.length - 1; i >= 0; i--) {
      for (var j = _quizs[i].choices.length - 1; j >= 0; j--) {
        var m = random.nextInt(j + 1);
        var temp2 = _quizs[i].choices[j];
        _quizs[i].choices[j] = _quizs[i].choices[m];
        _quizs[i].choices[m] = temp2;
      }
    }
    GroupValue.clear();
    for (var i = 0; i < _quizs.length; i++) {
      GroupValue.add(_quizs[i].choices[0].id);
    }
    setState(() {
      _quizs = _quizs;
      GroupValue = GroupValue;
      checkSend = false;
    });
  }

  void _loadjson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/manu.json');
      final jsdata = quizModelFromJson(response);
      print(jsonEncode(jsdata));
      int jscount = jsdata.length;
      setState(() {
        SelectChoice = List.filled(jscount, 1);
        _quizs = jsdata;
        shuffle(_quizs);
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadjson();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
  title: Text(
    "AI & Machine Learning",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,  // ปรับขนาดของข้อความตามต้องการ
      letterSpacing: 1.0,  // ปรับระยะห่างของตัวอักษร
      shadows: [
        Shadow(
          color: Colors.orange,  // สีของเงา
          blurRadius: 2.0,  // ขนาดของเงา
          offset: Offset(1.0, 2.0),  // ตำแหน่งของเงา
        ),
      ],
    ),
  ),
  actions: [
    PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'shuffleQuiz') {
          shuffleQuiz();
        } else if (value == 'shuffleChoice') {
          shuffleChoice();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'shuffleQuiz',
          child: Text('สลับข้อสอบ'),
        ),
        PopupMenuItem<String>(
          value: 'shuffleChoice',
          child: Text('สลับตัวเลือก'),
        ),
      ],
    ),
  ],
  backgroundColor: Color.fromARGB(255, 27, 45, 68),
  foregroundColor: Colors.white,
  bottom: TabBar(
    labelStyle: TextStyle(fontSize: 18),
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white.withOpacity(0.5),
    indicatorColor: Colors.white,
    overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
    tabs: [
      Tab(
        text: "ข้อสอบ",
      ),
      Tab(
        text: "ตรวจคำตอบ",
      ),
    ],
  ),
),


        body: TabBarView(
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          for (var i = 0; i < _quizs.length; i++)
                            Card(
                              margin: const EdgeInsets.all(10),
                              color: Color.fromARGB(255, 243, 243, 243),
                              shadowColor: const Color.fromARGB(255, 27, 45, 68),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Container(
                                      width: double.infinity,
                                      child: Text(
                                        "${i + 1}.${_quizs[i].title}",
                                        // textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  for (var j = 0;
                                      j < _quizs[i].choices.length;
                                      j++)
                                    RadioListTile(
                                      activeColor: Color.fromARGB(255, 25, 84, 21),
                                      title: Text(_quizs[i].choices[j].title),
                                      value: _quizs[i].choices[j].id,
                                      groupValue: GroupValue[i],
                                      onChanged: (value) {
                                        setState(() {
                                          GroupValue[i] = value;
                                        });
                                        print(GroupValue);
                                      },
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color.fromARGB(255, 27, 45, 68),
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Score = 0;
                            for (var i = 0; i < _quizs.length; i++) {
                              if (GroupValue[i] == _quizs[i].answerId) {
                                Score++;
                              }
                            }
                            setState(() {
                              Score = Score;
                              checkSend = true;
                            });
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'คะแนนของคุณ',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    '$Score',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(0),
                                  actionsPadding: EdgeInsets.all(5),
                                  titlePadding: EdgeInsets.all(10),
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
                            print(Score);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              
                              Text('ส่งข้อสอบ',style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              
                              ),),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 12, 77, 14),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          ),
                        ),
                        Text(
                          'Score: $Score  ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 201, 107, 44),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: checkSend
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                for (var i = 0; i < _quizs.length; i++)
                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    color: Colors.white,
                                    shadowColor: Colors.black,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Color.fromARGB(255, 0, 77, 177),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: Container(
                                            width: double.infinity,
                                            child: Text(
                                              "${i + 1}.${_quizs[i].title}",
                                              // textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        for (var j = 0;
                                            j < _quizs[i].choices.length;
                                            j++)
                                          RadioListTile(
                                            secondary: Icon(
                                              _quizs[i].choices[j].id ==
                                                      _quizs[i].answerId
                                                  ? Icons.check
                                                  : Icons.close,
                                              color: _quizs[i].choices[j].id ==
                                                      _quizs[i].answerId
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            enableFeedback: false,
                                            activeColor: Color.fromARGB(255, 0, 77, 177),
                                            title: Text(
                                                _quizs[i].choices[j].title),
                                            value: _quizs[i].choices[j].id,
                                            groupValue: GroupValue[i],
                                            onChanged: (value) {},
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text('คุณยังไม่ได้ส่งข้อสอบ'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

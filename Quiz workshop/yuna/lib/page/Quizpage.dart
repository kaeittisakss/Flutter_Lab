import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yuna/Model/Quiz.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuizModel> _quizzes = [];
  List<int> _groupValues = [];
  int _score = 0;
  bool _isAnswerSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  void _loadJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/manu.json');
      setState(() {
        _quizzes = quizModelFromJson(response);
        _shuffleQuizzes();
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  void _shuffleQuizzes() {
    _quizzes.shuffle(Random());
    _groupValues = List.generate(
        _quizzes.length, (index) => _quizzes[index].choices.first.id);
    _isAnswerSubmitted = false;
    setState(() {});
  }

  void _shuffleChoices() {
    for (var quiz in _quizzes) {
      quiz.choices.shuffle(Random());
    }
    _shuffleQuizzes();
  }

  void _submitAnswers() {
    _score = _quizzes
        .where((quiz) => quiz.answerId == _groupValues[_quizzes.indexOf(quiz)])
        .length;
    _isAnswerSubmitted = true;
    setState(() {});
    _showScoreDialog();
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Score', textAlign: TextAlign.center),
        content: Text('$_score',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(children: [_buildQuizTab(), _buildAnswerTab()]),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title:
          const Text("QuizManU", style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        ElevatedButton(
          onPressed: _shuffleQuizzes,
          child: const Text('Shuffle Quiz'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 77, 177), foregroundColor: Colors.white),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _shuffleChoices,
          child: const Text('Shuffle Choices'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 77, 177), foregroundColor: Colors.white),
        ),
      ],
      bottom: const TabBar(
        tabs: [
          Tab(text: "Quiz"),
          Tab(text: "Answer"),
        ],
      ),
    );
  }

  Widget _buildQuizTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _quizzes.length,
            itemBuilder: (context, index) =>
                _buildQuizCard(_quizzes[index], index),
          ),
        ),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildAnswerTab() {
    if (!_isAnswerSubmitted) {
      return const Center(child: Text('Please submit answers first'));
    }
    return ListView.builder(
      itemCount: _quizzes.length,
      itemBuilder: (context, index) => _buildAnswerCard(_quizzes[index], index),
    );
  }

  Widget _buildQuizCard(QuizModel quiz, int index) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("${index + 1}. ${quiz.title}",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...quiz.choices.map((choice) => RadioListTile(
                title: Text(choice.title),
                value: choice.id,
                groupValue: _groupValues[index],
                onChanged: (value) {
                  setState(() => _groupValues[index] = value!);
                },
              )),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(QuizModel quiz, int index) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("${index + 1}. ${quiz.title}",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...quiz.choices.map((choice) => ListTile(
                title: Text(choice.title),
                leading: Icon(
                  choice.id == quiz.answerId ? Icons.check : Icons.close,
                  color: choice.id == quiz.answerId ? Colors.green : Colors.red,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      color: Colors.red[900],
      child: ElevatedButton(
        onPressed: _submitAnswers,
        style: ElevatedButton.styleFrom(primary: Colors.red[900]),
        child: const Text('Submit Answers'),
      ),
    );
  }
}

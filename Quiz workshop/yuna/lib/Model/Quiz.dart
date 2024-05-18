import 'dart:convert';

import 'package:yuna/Model/Choice.dart';

List<QuizModel> quizModelFromJson(
        String str) => //คือ การแปลงข้อมูลจาก json ให้เป็น object
    List<QuizModel>.from(json.decode(str).map((x) => QuizModel.fromJson(x)));

String quizModelToJson(
        List<QuizModel> data) => //คือ การแปลงข้อมูลจาก object ให้เป็น json
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuizModel {
  String title;
  List<Choice> choices;
  int answerId;
  QuizModel({
    required this.title,
    required this.choices,
    required this.answerId,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      title: json['title'],
      choices:
          List<Choice>.from(json['choices'].map((x) => Choice.fromJson(x))),
      answerId: json['answerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'choices': choices.map((x) => x.toJson()).toList(),
      'answerId': answerId,
    };
  }
}

import 'dart:convert';

class Choice {
  int id;
  String title;
  Choice({
    required this.id,
    required this.title,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

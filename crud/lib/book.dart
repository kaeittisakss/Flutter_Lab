class Book {
  final int? id;
  final String name;
  final int price;
  Book({this.id, required this.name, required this.price});
  Map<String, Object?> tojson() => {"id": id, "name": name, "price": price};
  static Book fromjson(Map<String, Object> json) => Book(
      id: json["id"] as int,
      name: json["name"] as String,
      price: json["price"] as int);
}

class Note {
  int? id;
  String title;
  String description;
  String date;
  int color;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'color': color,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      color: map['color'],
    );
  }
}
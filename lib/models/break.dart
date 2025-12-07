
class Break {
  final String start;
  final String end;

  Break({required this.start, required this.end});

  factory Break.fromJson(Map<String, dynamic> json) {
    return Break(
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}



class Unavailability {
  final String type;
  final String reason;
  final String date;

  Unavailability({
    required this.type,
    required this.reason,
    required this.date,
  });

  factory Unavailability.fromJson(Map<String, dynamic> json) {
    return Unavailability(
      type: json['type'] ?? '',
      reason: json['reason'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'reason': reason,
      'date': date,
    };
  }
}


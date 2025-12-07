
class Service {
  final String id;
  final String name;
  final String color;
  final int duration;

  Service({
    required this.id,
    required this.name,
    required this.color,
    required this.duration,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '#DC2626',
      duration: json['duration'] ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'duration': duration,
    };
  }
}

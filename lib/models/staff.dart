
class Staff {
  final String id;
  final String name;
  final String color;
  final String avatar;

  Staff({
    required this.id,
    required this.name,
    required this.color,
    required this.avatar,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '#F97316',
      avatar: json['avatar'] ?? json['name']?.substring(0, 2)?.toUpperCase() ?? 'ST',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'avatar': avatar,
    };
  }
}

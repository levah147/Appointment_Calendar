
class Customer {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? avatar;

  Customer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.avatar,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'avatar': avatar,
    };
  }
}

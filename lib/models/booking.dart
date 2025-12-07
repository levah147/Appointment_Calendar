
import 'customer.dart';
import 'service.dart';

class Booking {
  final String id;
  final String startTime;
  final String endTime;
  final String status;
  final Customer customer;
  final Service service;

  Booking({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.customer,
    required this.service,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      status: json['status'] ?? 'pending',
      customer: Customer.fromJson(json['customer'] ?? {}),
      service: Service.fromJson(json['service'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'customer': customer.toJson(),
      'service': service.toJson(),
    };
  }
}

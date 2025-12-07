
import 'staff.dart';
import 'working_hours.dart';
import 'break.dart';
import 'unavailability.dart';
import 'booking.dart';

class StaffBooking {
  final Staff staff;
  final WorkingHours? workingHours;
  final List<Break> breaks;
  final List<Unavailability> unavailability;
  final List<Booking> bookings;

  StaffBooking({
    required this.staff,
    this.workingHours,
    required this.breaks,
    required this.unavailability,
    required this.bookings,
  });

  factory StaffBooking.fromJson(Map<String, dynamic> json) {
    return StaffBooking(
      staff: Staff.fromJson(json['staff'] ?? {}),
      workingHours: json['workingHours'] != null
          ? WorkingHours.fromJson(json['workingHours'])
          : null,
      breaks: (json['breaks'] as List?)
              ?.map((b) => Break.fromJson(b))
              .toList() ??
          [],
      unavailability: (json['unavailability'] as List?)
              ?.map((u) => Unavailability.fromJson(u))
              .toList() ??
          [],
      bookings: (json['bookings'] as List?)
              ?.map((b) => Booking.fromJson(b))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff': staff.toJson(),
      'workingHours': workingHours?.toJson(),
      'breaks': breaks.map((b) => b.toJson()).toList(),
      'unavailability': unavailability.map((u) => u.toJson()).toList(),
      'bookings': bookings.map((b) => b.toJson()).toList(),
    };
  }
}

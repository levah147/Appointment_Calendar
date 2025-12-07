import 'package:flutter/material.dart';

class TimeCalculations {
  // Convert time string (HH:mm) to pixel position
  static double timeToPosition(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final totalMinutes = hours * 60 + minutes;
    return (totalMinutes ~/ 15) * 20.0;
  }

  // Calculate duration in pixels between two times
  static double getDuration(String startTime, String endTime) {
    final startParts = startTime.split(':');
    final startHours = int.parse(startParts[0]);
    final startMinutes = int.parse(startParts[1]);
    final startTotal = startHours * 60 + startMinutes;

    final endParts = endTime.split(':');
    final endHours = int.parse(endParts[0]);
    final endMinutes = int.parse(endParts[1]);
    final endTotal = endHours * 60 + endMinutes;

    return ((endTotal - startTotal) ~/ 15) * 20.0;
  }

  // Format time for display (12-hour format with am/pm)
  static String formatTimeDisplay(String time) {
    final parts = time.split(':');
    int hours = int.parse(parts[0]);
    final minutes = parts[1];
    final period = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    if (hours == 0) hours = 12;
    return '$hours:$minutes $period';
  }

  // Get color based on booking status
  static Color getBookingColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFFDBEAFE); // Light blue
      case 'pending':
        return const Color(0xFFFEF3C7); // Light yellow
      case 'in_progress':
        return const Color(0xFFDCFCE7); // Light green
      case 'completed':
        return const Color(0xFFF3F4F6); // Light grey
      case 'cancelled':
        return const Color(0xFFFEE2E2); // Light red
      default:
        return const Color(0xFFDBEAFE);
    }
  }

  // Get border color based on booking status
  static Color getBookingBorderColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF3B82F6); // Blue
      case 'pending':
        return const Color(0xFFF59E0B); // Yellow/Orange
      case 'in_progress':
        return const Color(0xFF10B981); // Green
      case 'completed':
        return const Color(0xFF6B7280); // Grey
      case 'cancelled':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF3B82F6);
    }
  }

  // Generate time slots for the entire day (every 15 minutes)
  static List<String> generateTimeSlots() {
    final slots = <String>[];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        slots.add(
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
        );
      }
    }
    return slots;
  }

  // Get current time position in pixels
  static double getCurrentTimePosition() {
    final now = DateTime.now();
    final totalMinutes = now.hour * 60 + now.minute;
    return (totalMinutes / 15) * 20.0;
  }

  // Get current time as a string (HH:mm format)
  static String getCurrentTimeString() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

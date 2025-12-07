import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/staff_booking.dart';

class DataService {
  // Load sample data from JSON asset file
  static Future<List<StaffBooking>> loadStaffBookings() async {
    try {
      // Load JSON string from assets
      final String jsonString = await rootBundle.loadString('assets/data/sample_data.json');
      
      // Parse JSON
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Extract staff bookings array
      final List<dynamic> staffBookingsJson = jsonData['data']['staffBookings'] as List;
      
      // Convert to StaffBooking objects
      final List<StaffBooking> staffBookings = staffBookingsJson
          .map((json) => StaffBooking.fromJson(json))
          .toList();
      
      return staffBookings;
    } catch (e) {
      print('Error loading staff bookings: $e');
      return [];
    }
  }

  // You can add more methods here for API calls in the future
  // static Future<List<StaffBooking>> fetchStaffBookingsFromAPI(DateTime date) async {
  //   // API call implementation
  // }
}

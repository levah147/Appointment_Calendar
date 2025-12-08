import 'package:flutter/material.dart';
import '../models/staff_booking.dart';
import '../models/booking.dart';
import 'staff_column_widget.dart';

/// Main calendar grid displaying staff columns with appointments
class CalendarGrid extends StatelessWidget {
  final List<StaffBooking> staffBookings;
  final ScrollController verticalController;
  final ScrollController horizontalController;
  final double currentTimePosition;
  final String currentTimeString;

  const CalendarGrid({
    Key? key,
    required this.staffBookings,
    required this.verticalController,
    required this.horizontalController,
    required this.currentTimePosition,
    required this.currentTimeString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: verticalController,
        physics: const ClampingScrollPhysics(),
        child: SingleChildScrollView(
          controller: horizontalController,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            height: 1920,
            child: Stack(
              children: [
                // Staff columns
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: staffBookings.map((staffBooking) {
                    return StaffColumnWidget(
                      staffBooking: staffBooking,
                      currentTimePosition: currentTimePosition,
                      currentTimeString: currentTimeString,
                      onTimeSlotTap: (time) {
                        print('Tapped on ${staffBooking.staff.name} at $time');
                      },
                      onBookingTap: (booking) {
                        print('Tapped on booking: ${booking.id}');
                      },
                    );
                  }).toList(),
                ),
                // Continuous red line across all staff columns
                Positioned(
                  top: currentTimePosition,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

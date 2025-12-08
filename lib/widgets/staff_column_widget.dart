import 'package:flutter/material.dart';
import '../models/staff_booking.dart';
import '../models/booking.dart';
import '../utils/time_calculations.dart';
import '../theme/app_theme.dart';

class StaffColumnWidget extends StatelessWidget {
  final StaffBooking staffBooking;
  final double currentTimePosition;
  final String currentTimeString;
  final Function(String) onTimeSlotTap;
  final Function(Booking) onBookingTap;

  const StaffColumnWidget({
    Key? key,
    required this.staffBooking,
    required this.currentTimePosition,
    required this.currentTimeString,
    required this.onTimeSlotTap,
    required this.onBookingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUnavailable = staffBooking.unavailability.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(color: AppTheme.getBorderColor(context)),
        ),
      ),
      child: SizedBox(
        height: 1920,
        child: Stack(
          children: [
            // Working Hours Background
            if (!isUnavailable && staffBooking.workingHours != null)
              Positioned(
                top: TimeCalculations.timeToPosition(
                    staffBooking.workingHours!.start),
                left: 0,
                right: 0,
                height: TimeCalculations.getDuration(
                  staffBooking.workingHours!.start,
                  staffBooking.workingHours!.end,
                ),
                child: Container(
                  color: AppTheme.getWorkingHoursColor(context),
                ),
              ),

            // Unavailability Overlay
            if (isUnavailable)
              Positioned.fill(
                child: Container(
                  color: AppTheme.getUnavailableColor(context),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Day Off',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Not scheduled',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isDark ? Colors.grey[500] : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Time Grid Lines (Clickable slots)
            if (!isUnavailable)
              for (int i = 0; i < 96; i++)
                Positioned(
                  top: i * 20.0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      final hour = (i * 15) ~/ 60;
                      final minute = (i * 15) % 60;
                      final time =
                          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                      onTimeSlotTap(time);
                    },
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: i % 4 == 0
                                ? AppTheme.getGridLineColor(context)
                                : AppTheme.getGridLineColor(context)
                                    .withOpacity(0.5),
                            width: i % 4 == 0 ? 1 : 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

            // Breaks
            if (!isUnavailable)
              for (var breakItem in staffBooking.breaks)
                Positioned(
                  top: TimeCalculations.timeToPosition(breakItem.start),
                  left: 4,
                  right: 4,
                  height: TimeCalculations.getDuration(
                      breakItem.start, breakItem.end),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.getBreakBackgroundColor(context),
                      border: Border.all(
                        color: AppTheme.getBreakBorderColor(context),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        const Text('☕', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          'Break',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            // Bookings
            if (!isUnavailable)
              for (var booking in staffBooking.bookings)
                Positioned(
                  top: TimeCalculations.timeToPosition(booking.startTime),
                  left: 4,
                  right: 4,
                  height: TimeCalculations.getDuration(
                      booking.startTime, booking.endTime),
                  child: GestureDetector(
                    onTap: () => onBookingTap(booking),
                    child: Container(
                      decoration: BoxDecoration(
                        color: TimeCalculations.getBookingColor(booking.status),
                        border: Border.all(
                          color: TimeCalculations.getBookingBorderColor(
                              booking.status),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${booking.startTime} - ${booking.customer.name}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking.service.name,
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

            // Note: Current time indicator line is now rendered in the parent calendar grid
            // to ensure it's continuous across all staff columns without joints
          ],
        ),
      ),
    );
  }
}

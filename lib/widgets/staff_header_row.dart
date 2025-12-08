import 'package:flutter/material.dart';
import '../models/staff_booking.dart';
import '../theme/app_theme.dart';

/// Row displaying staff avatars and names at the top of the calendar
class StaffHeaderRow extends StatelessWidget {
  final List<StaffBooking> staffBookings;
  final ScrollController scrollController;

  const StaffHeaderRow({
    Key? key,
    required this.staffBookings,
    required this.scrollController,
  }) : super(key: key);

  Widget _buildStaffHeader(BuildContext context, StaffBooking staffBooking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnavailable = staffBooking.unavailability.isNotEmpty;

    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFBFDBFE),
                width: 3,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isUnavailable
                    ? (isDark ? Colors.grey[700] : Colors.grey[400])
                    : const Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  staffBooking.staff.avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              staffBooking.staff.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.getBorderColor(context)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            // blurRadius: 10,
            // offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(
          children: staffBookings.map((staffBooking) {
            return _buildStaffHeader(context, staffBooking);
          }).toList(),
        ),
      ),
    );
  }
}

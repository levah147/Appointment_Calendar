import 'package:flutter/material.dart';

/// Calendar header with navigation, date selector, and action icons
class CalendarHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback? onDatePickerTap;

  const CalendarHeader({
    Key? key,
    required this.selectedDate,
    this.onDatePickerTap,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.menu,
                  size: 24,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onDatePickerTap,
                child: Row(
                  children: [
                    Text(
                      _formatDate(selectedDate),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down,
                        size: 20,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.tune,
                  size: 22,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              const SizedBox(width: 16),
              Stack(
                children: [
                  Icon(Icons.notifications_outlined,
                      size: 22,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.brown[300],
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'R',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

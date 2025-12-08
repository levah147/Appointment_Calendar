import 'package:flutter/material.dart';
import '../utils/time_calculations.dart';
import '../theme/app_theme.dart';

/// Time column displaying hours on the left side of the calendar
class TimeColumn extends StatelessWidget {
  final ScrollController scrollController;
  final double currentTimePosition;
  final String currentTimeString;

  const TimeColumn({
    Key? key,
    required this.scrollController,
    required this.currentTimePosition,
    required this.currentTimeString,
  }) : super(key: key);

  bool _isCurrentHour(int hour) {
    final now = DateTime.now();
    return now.hour == hour;
  }

  Widget _buildTwoLineTime(BuildContext context, String time) {
    final parts = time.split(':');
    int hours = int.parse(parts[0]);
    final period = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    if (hours == 0) hours = 12;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$hours:00',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.getTimeTextColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          period,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.getTimeTextColor(context),
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Spacer for staff header (fixed height)
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: AppTheme.getBorderColor(context)),
              ),
            ),
          ),
          // Time labels (scrollable vertically)
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                height: 1920,
                child: Stack(
                  children: [
                    // Time labels (two-line format)
                    for (int i = 0; i < 24; i++)
                      Positioned(
                        top: i * 80.0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 80,
                          child: Center(
                            child: _buildTwoLineTime(
                              context,
                              '${i.toString().padLeft(2, '0')}:00',
                            ),
                          ),
                        ),
                      ),
                    // Current time indicator line (red line)
                    Positioned(
                      top: currentTimePosition,
                      left: 0,
                      right: 0,
                      child: Container(
                        // height: 1,
                        color: Colors.red,
                      ),
                    ),
                    // Current time tooltip/bubble (red line goes through middle)
                    Positioned(
                      top: currentTimePosition - 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            TimeCalculations.formatTimeDisplay(
                                currentTimeString),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

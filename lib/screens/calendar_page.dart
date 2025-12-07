import 'package:flutter/material.dart';
import 'dart:async';
import '../models/staff_booking.dart';
import '../models/booking.dart';
import '../utils/time_calculations.dart';
import '../services/data_service.dart';
import '../widgets/staff_column_widget.dart';
import '../theme/app_theme.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime selectedDate;
  late List<String> timeSlots;
  List<StaffBooking> staffBookings = [];
  late double currentTimePosition;
  late String currentTimeString;
  Timer? _timer;
  bool isLoading = true;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _timeColumnScrollController = ScrollController();
  final ScrollController _calendarGridVerticalController = ScrollController();
  final ScrollController _staffHeaderScrollController = ScrollController();
  final ScrollController _calendarGridHorizontalController = ScrollController();

  bool _isSyncingScroll = false;
  bool _isSyncingHorizontalScroll = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    timeSlots = TimeCalculations.generateTimeSlots();
    currentTimePosition = TimeCalculations.getCurrentTimePosition();
    currentTimeString = TimeCalculations.getCurrentTimeString();

    // Setup scroll synchronization
    _setupScrollSynchronization();

    // Load data from assets
    _loadData();

    // Update current time every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        currentTimePosition = TimeCalculations.getCurrentTimePosition();
        currentTimeString = TimeCalculations.getCurrentTimeString();
      });
    });
  }

  void _setupScrollSynchronization() {
    // Sync time column scroll to calendar grid (vertical)
    _timeColumnScrollController.addListener(() {
      if (!_isSyncingScroll && _calendarGridVerticalController.hasClients) {
        _isSyncingScroll = true;
        _calendarGridVerticalController
            .jumpTo(_timeColumnScrollController.offset);
        _isSyncingScroll = false;
      }
    });

    // Sync calendar grid scroll to time column (vertical)
    _calendarGridVerticalController.addListener(() {
      if (!_isSyncingScroll && _timeColumnScrollController.hasClients) {
        _isSyncingScroll = true;
        _timeColumnScrollController
            .jumpTo(_calendarGridVerticalController.offset);
        _isSyncingScroll = false;
      }
    });

    // Sync staff header scroll to calendar grid (horizontal)
    _staffHeaderScrollController.addListener(() {
      if (!_isSyncingHorizontalScroll &&
          _calendarGridHorizontalController.hasClients) {
        _isSyncingHorizontalScroll = true;
        _calendarGridHorizontalController
            .jumpTo(_staffHeaderScrollController.offset);
        _isSyncingHorizontalScroll = false;
      }
    });

    // Sync calendar grid scroll to staff header (horizontal)
    _calendarGridHorizontalController.addListener(() {
      if (!_isSyncingHorizontalScroll &&
          _staffHeaderScrollController.hasClients) {
        _isSyncingHorizontalScroll = true;
        _staffHeaderScrollController
            .jumpTo(_calendarGridHorizontalController.offset);
        _isSyncingHorizontalScroll = false;
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final data = await DataService.loadStaffBookings();
    setState(() {
      staffBookings = data;
      isLoading = false;
    });

    // Scroll to current time after data is loaded and UI is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
      _syncHorizontalScrollPositions();
    });
  }

  void _syncHorizontalScrollPositions() {
    // Ensure staff header and calendar grid start with the same scroll position
    if (_staffHeaderScrollController.hasClients &&
        _calendarGridHorizontalController.hasClients) {
      final headerOffset = _staffHeaderScrollController.offset;
      final gridOffset = _calendarGridHorizontalController.offset;

      if (headerOffset != gridOffset) {
        _isSyncingHorizontalScroll = true;
        _calendarGridHorizontalController.jumpTo(headerOffset);
        _isSyncingHorizontalScroll = false;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _timeColumnScrollController.dispose();
    _calendarGridVerticalController.dispose();
    _staffHeaderScrollController.dispose();
    _calendarGridHorizontalController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTime() {
    // Check if controllers are attached before scrolling
    if (!_timeColumnScrollController.hasClients ||
        !_calendarGridVerticalController.hasClients) return;

    final scrollPosition = currentTimePosition - 200;
    if (scrollPosition > 0 && scrollPosition < 1920 - 400) {
      _isSyncingScroll = true;
      _timeColumnScrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _calendarGridVerticalController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _isSyncingScroll = false;
    }
  }

  bool _isCurrentHour(int hour) {
    final now = DateTime.now();
    return now.hour == hour;
  }

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

  void _previousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

  void _goToToday() {
    setState(() {
      selectedDate = DateTime.now();
    });
    _scrollToCurrentTime();
  }

  // Build staff header widget
  Widget _buildStaffHeader(BuildContext context, StaffBooking staffBooking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnavailable = staffBooking.unavailability.isNotEmpty;

    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(color: AppTheme.getBorderColor(context)),
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Purple Banner
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.rocket_launch_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Continue setup',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),

            // Header
            Container(
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
                        onTap: () {
                          // Show date picker
                        },
                        child: Row(
                          children: [
                            Text(
                              _formatDate(selectedDate),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down,
                                size: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color),
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
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
            ),

            // Main Calendar Area
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time Column (Fixed Left - Scrolls Vertically Only)
                        Container(
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
                                    bottom: BorderSide(
                                        color:
                                            AppTheme.getBorderColor(context)),
                                  ),
                                ),
                              ),
                              // Time labels (scrollable vertically)
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: _timeColumnScrollController,
                                  physics: const ClampingScrollPhysics(),
                                  child: SizedBox(
                                    height: 1920,
                                    child: Stack(
                                      children: [
                                        // Time labels
                                        for (int i = 0; i < 24; i++)
                                          Positioned(
                                            top: i * 80.0,
                                            left: 0,
                                            right: 0,
                                            child: SizedBox(
                                              height: 80,
                                              child: Center(
                                                child: Text(
                                                  TimeCalculations
                                                      .formatTimeDisplay(
                                                    '${i.toString().padLeft(2, '0')}:00',
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: _isCurrentHour(i)
                                                        ? Colors.red
                                                        : AppTheme
                                                            .getTimeTextColor(
                                                                context),
                                                    fontWeight:
                                                        _isCurrentHour(i)
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),
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
                                            height: 2,
                                            color: Colors.red,
                                          ),
                                        ),
                                        // Current time indicator circle
                                        Positioned(
                                          top: currentTimePosition - 8,
                                          left: -8,
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
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
                        ),

                        // Right Side: Staff Header + Calendar Grid
                        Expanded(
                          child: Column(
                            children: [
                              // Staff Header Row (Fixed at top, scrolls horizontally only)
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border(
                                    bottom: BorderSide(
                                        color:
                                            AppTheme.getBorderColor(context)),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  controller: _staffHeaderScrollController,
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  child: Row(
                                    children: staffBookings.map((staffBooking) {
                                      return _buildStaffHeader(
                                          context, staffBooking);
                                    }).toList(),
                                  ),
                                ),
                              ),

                              // Calendar Grid (Scrolls both vertically and horizontally)
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: _calendarGridVerticalController,
                                  physics: const ClampingScrollPhysics(),
                                  child: SingleChildScrollView(
                                    controller:
                                        _calendarGridHorizontalController,
                                    scrollDirection: Axis.horizontal,
                                    physics: const ClampingScrollPhysics(),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          staffBookings.map((staffBooking) {
                                        return StaffColumnWidget(
                                          staffBooking: staffBooking,
                                          currentTimePosition:
                                              currentTimePosition,
                                          currentTimeString: currentTimeString,
                                          onTimeSlotTap: (time) {
                                            print(
                                                'Tapped on ${staffBooking.staff.name} at $time');
                                          },
                                          onBookingTap: (booking) {
                                            print(
                                                'Tapped on booking: ${booking.id}');
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),

      // Floating Action Buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 4,
            onPressed: _goToToday,
            child: Icon(Icons.event_repeat_outlined,
                color: Theme.of(context).textTheme.bodyLarge?.color, size: 25),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            mini: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 4,
            onPressed: () {},
            child: Icon(Icons.groups_outlined,
                color: Theme.of(context).textTheme.bodyLarge?.color, size: 25),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.calendar_today,
                  color: Theme.of(context).primaryColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.local_offer_outlined,
                  color: Theme.of(context).textTheme.bodySmall?.color),
              onPressed: () {},
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 32),
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(Icons.emoji_emotions_outlined,
                  color: Theme.of(context).textTheme.bodySmall?.color),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.grid_view,
                  color: Theme.of(context).textTheme.bodySmall?.color),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

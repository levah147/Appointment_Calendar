import 'package:flutter/material.dart';
import 'dart:async';
import '../models/staff_booking.dart';
import '../utils/time_calculations.dart';
import '../services/data_service.dart';
import '../widgets/setup_banner.dart';
import '../widgets/calendar_header.dart';
import '../widgets/time_column.dart';
import '../widgets/staff_header_row.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_bottom_nav.dart';
import '../widgets/calendar_fab_menu.dart';

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

  void _goToToday() {
    setState(() {
      selectedDate = DateTime.now();
    });
    _scrollToCurrentTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Purple Banner
            const SetupBanner(),

            // Header
            CalendarHeader(
              selectedDate: selectedDate,
              onDatePickerTap: () {
                // Show date picker
              },
            ),

            // Main Calendar Area
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time Column (Fixed Left - Scrolls Vertically Only)
                        TimeColumn(
                          scrollController: _timeColumnScrollController,
                          currentTimePosition: currentTimePosition,
                          currentTimeString: currentTimeString,
                        ),

                        // Right Side: Staff Header + Calendar Grid
                        Expanded(
                          child: Column(
                            children: [
                              // Staff Header Row
                              StaffHeaderRow(
                                staffBookings: staffBookings,
                                scrollController: _staffHeaderScrollController,
                              ),

                              // Calendar Grid
                              CalendarGrid(
                                staffBookings: staffBookings,
                                verticalController:
                                    _calendarGridVerticalController,
                                horizontalController:
                                    _calendarGridHorizontalController,
                                currentTimePosition: currentTimePosition,
                                currentTimeString: currentTimeString,
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
      floatingActionButton: CalendarFabMenu(
        onGoToToday: _goToToday,
      ),

      // Bottom Navigation
      bottomNavigationBar: const CalendarBottomNav(),
    );
  }
}


// ================================================================================
// FILE: lib/main.dart
// ================================================================================

import 'package:flutter/material.dart';
import 'screens/calendar_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AppointmentCalendarApp());
}

class AppointmentCalendarApp extends StatelessWidget {
  const AppointmentCalendarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment Calendar',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Automatically switch based on system
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const CalendarPage(),
    );
  }
}

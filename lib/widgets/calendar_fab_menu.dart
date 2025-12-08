import 'package:flutter/material.dart';

/// Floating action buttons for calendar quick actions
class CalendarFabMenu extends StatelessWidget {
  final VoidCallback onGoToToday;

  const CalendarFabMenu({
    Key? key,
    required this.onGoToToday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          mini: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 4,
          onPressed: onGoToToday,
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
    );
  }
}

import 'package:flutter/material.dart';

/// Bottom navigation bar for the calendar
class CalendarBottomNav extends StatelessWidget {
  const CalendarBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

import 'package:flutter/material.dart';

import 'flight_ticket_booking_card.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Show the TicketCard directly as the home so the UI from the
      // screenshot is visible immediately.
      home: const Scaffold(
        backgroundColor: Color(0xFFF7F6FB),
        body: SafeArea(
          child: Center(
            child: TicketCard(),
          ),
        ),
      ),
    );
  }
}

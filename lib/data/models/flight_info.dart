import 'package:flight_ticket_booking_card/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
/// A model representing flight timing information, including departure,
/// arrival, and total duration.
///
/// This class is useful for flight-related UIs, such as ticket cards,
/// schedules, or calculating arrival times based on departure and duration.
class FlightInfo {
  final String flightNumber;
  final Duration flightDuration;
  final DateTime departureTime;
  final DateTime arrivalTime;

  FlightInfo({
    required this.flightNumber,
    required this.flightDuration,
    required this.departureTime,
    required this.arrivalTime,
  });

  String get departureDateFormatted {
    return departureTime.toFormattedString();
  }

  String get arrivalDateFormatted {
    return arrivalTime.toFormattedString();
  }
}
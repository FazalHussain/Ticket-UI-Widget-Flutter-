import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// A utility class that calculates flight durations between two airports
/// based on their IATA codes, local departure/arrival times, and time zones.
///
/// This class depends on a JSON file (`assets/airports.json`) containing
/// airport information, including IATA codes and their corresponding time zones.
///
/// Example of a valid JSON entry:
/// ```json
/// {
///   "00AK": {
///     "icao": "00AK",
///     "iata": "ANC",
///     "name": "Ted Stevens Anchorage International Airport",
///     "country": "US",
///     "tz": "America/Anchorage"
///   }
/// }
/// ```
///
/// Ensure that `airports.json` is listed under `flutter/assets` in `pubspec.yaml`.
///
/// Example:
/// ```yaml
/// flutter:
///   assets:
///     - assets/airports.json
/// ```
class FlightTimeCalculator {
  // Load airports JSON and get timezone for IATA
  static Future<String> getIATATimezone(String iata) async {
    // Load JSON from file
    final jsonString = await rootBundle.loadString('assets/airports.json');

    // Decode as Map
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Convert map values to a List by filtering non empty IATA codes
    final List<dynamic> airports = jsonMap.values
        .where((airport) => (airport['iata'] as String?)?.isNotEmpty ?? false)
        .toList();

    // Find airport by IATA code
    final airport = airports.firstWhere((a) => a['iata'] == iata, orElse: () => null);

    // Throw Exception if airport not found
    if (airport == null) throw Exception('IATA code not found: $iata');
    return airport['tz'];
  }

  // Calculate flight duration considering IATA time zones
  static Future<Duration> calculateFlightDuration({
    required String fromIATA,
    required String toIATA,
    required String fromTime, // HH:mm
    required String toTime,   // HH:mm
    required DateTime flightDate, // Flight date
  }) async {
    try {
      tz.initializeTimeZones();

      // Get time zones for both IATA codes
      final fromTz = await getIATATimezone(fromIATA);
      final toTz = await getIATATimezone(toIATA);

      // Get locations
      final fromLocation = tz.getLocation(fromTz);
      final toLocation = tz.getLocation(toTz);

      // Parse times
      final fromParts = fromTime.split(':');
      final toParts = toTime.split(':');

      // Flight departure times in respective time zones
      final fromDateTime = tz.TZDateTime(
        fromLocation,
        flightDate.year,
        flightDate.month,
        flightDate.day,
        int.parse(fromParts[0]),
        int.parse(fromParts[1]),
      );

      // Flight arrival times in respective time zones
      var toDateTime = tz.TZDateTime(
        toLocation,
        flightDate.year,
        flightDate.month,
        flightDate.day,
        int.parse(toParts[0]),
        int.parse(toParts[1]),
      );

      // Handle next-day flight
      if (toDateTime.isBefore(fromDateTime)) {
        toDateTime = toDateTime.add(const Duration(days: 1));
      }

      // Convert both to UTC and calculate duration
      final duration = toDateTime.toUtc().difference(fromDateTime.toUtc());
      return duration;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('⚠️ FlightTimeCalculator error: $e');
      }
      return Duration.zero;
    }

  }

  /// Returns the departure DateTime localized to the airport’s timezone.
  static Future<tz.TZDateTime> getDepartureDateTime({
    required String fromIATA,
    required String fromTime, // HH:mm
    required DateTime flightDate,
  }) async {
    tz.initializeTimeZones();

    final fromTz = await getIATATimezone(fromIATA);
    final fromLocation = tz.getLocation(fromTz);
    final fromParts = fromTime.split(':');

    if (fromParts.length != 2) {
      throw Exception('Invalid departure time format (expected HH:mm)');
    }

    return tz.TZDateTime(
      fromLocation,
      flightDate.year,
      flightDate.month,
      flightDate.day,
      int.parse(fromParts[0]),
      int.parse(fromParts[1]),
    );
  }

  /// Returns the arrival DateTime localized to the destination airport’s timezone.
  ///
  /// If the arrival time is before departure time, it automatically adjusts
  /// to the next calendar day.
  static Future<tz.TZDateTime> getArrivalDateTime({
    required String fromIATA,
    required String toIATA,
    required String fromTime,
    required String toTime,
    required DateTime flightDate,
  }) async {
    tz.initializeTimeZones();

    final fromDateTime = await getDepartureDateTime(
      fromIATA: fromIATA,
      fromTime: fromTime,
      flightDate: flightDate,
    );

    final toTz = await getIATATimezone(toIATA);
    final toLocation = tz.getLocation(toTz);
    final toParts = toTime.split(':');

    if (toParts.length != 2) {
      throw Exception('Invalid arrival time format (expected HH:mm)');
    }

    var toDateTime = tz.TZDateTime(
      toLocation,
      flightDate.year,
      flightDate.month,
      flightDate.day,
      int.parse(toParts[0]),
      int.parse(toParts[1]),
    );

    // Handle next-day arrival
    if (toDateTime.isBefore(fromDateTime)) {
      toDateTime = toDateTime.add(const Duration(days: 1));
    }

    return toDateTime;
  }
}
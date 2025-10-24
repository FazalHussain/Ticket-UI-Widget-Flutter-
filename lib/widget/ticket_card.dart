import 'package:barcode_widget/barcode_widget.dart';
import 'package:flight_ticket_booking_card/utils/date_time.dart';
import 'package:flight_ticket_booking_card/utils/flight_time_calculator.dart';
import 'package:flight_ticket_booking_card/widget/ticket_shape.dart';
import 'package:flutter/material.dart';

import '../data/models/flight_info.dart';
import 'cut_separator.dart';

/// A reusable ticket card widget that mimics the provided screenshot.
/// Place `TicketCard()` anywhere in your app (for example in `lib/main.dart`) to show the UI.
class TicketCard extends StatelessWidget {
  final String fromCode;
  final String toCode;
  final String fromTime;
  final String toTime;
  final String dateLabel;
  final String passengerName;
  final String seat;
  final String travelClass;
  final String gate;
  // Exposed tuning parameters for the ticket shape so the border rounding
  // and notch behavior can be adjusted without editing the shape implementation.
  final double cardBorderRadius;
  final double cardNotchRadius;
  final double cardNotchOffsetFactor;
  final double cardBorderWidth;
  final String barcodeData;

  const TicketCard({
    super.key,
    this.fromCode = 'JFK',
    this.toCode = 'DXB',
    this.fromTime = '11:20',
    this.toTime = '07:55',
    this.dateLabel = 'Tue, 28 Oct',
    this.passengerName = 'Fazal Hussain',
    this.seat = 'A2',
    this.travelClass = 'Business',
    this.gate = '21',
    this.cardBorderRadius = 20,
    this.cardNotchRadius = 16,
    this.cardNotchOffsetFactor = 0.2,
    this.cardBorderWidth = 1.6,
    this.barcodeData = '2323456342234456456'
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FlightInfo>(
        future: _loadFlightInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final flightInfo = snapshot.data!;
          final duration = flightInfo.flightDuration;
          final departureDate = flightInfo.departureDateFormatted;
          final arrivalDate = flightInfo.arrivalDateFormatted;

          final flightDuration =
              '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';

          return _buildTicket(flightDuration, departureDate, arrivalDate);
        });
  }

  /// Loads both departure date and duration together
  Future<FlightInfo> _loadFlightInfo() async {
    final departureDate = await FlightTimeCalculator.getDepartureDateTime(
      fromIATA: fromCode,
      fromTime: fromTime,
      flightDate: dateLabel.toDateTime()
    );

    final arrivalDate = await FlightTimeCalculator.getArrivalDateTime(
        fromIATA: fromCode,
        toIATA: toCode,
        fromTime: fromTime,
        toTime: toTime,
        flightDate: dateLabel.toDateTime()
    );

    final duration = await FlightTimeCalculator.calculateFlightDuration(
      fromIATA: fromCode,
      toIATA: toCode,
      fromTime: fromTime,
      toTime: toTime,
      flightDate: departureDate,
    );

    return FlightInfo(
        flightNumber: '',
        departureTime: departureDate,
        arrivalTime: arrivalDate,
        flightDuration: duration
    );
  }


  Widget _buildTicket(String flightDuration, String departureDate, String arrivalDate) {
    const purple = Color(0xFF9B2CF3);
    return Padding(
        padding: const EdgeInsets.all(18.0),
        child: TicketShape(
          maxWidth: 420,
          borderColor: purple.withAlpha(230),
          // wire these to the exposed TicketCard tuning params so you can
          // tweak the visual without touching the shape implementation.
          borderRadius: cardBorderRadius,
          notchRadius: cardNotchRadius,
          notchOffsetFactor: cardNotchOffsetFactor,
          borderWidth: cardBorderWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // From
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fromCode,
                                style: const TextStyle(
                                    color: Color(0xFF9B2CF3),
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            Text(fromTime,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text(departureDate,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ],
                        ),

                        const Spacer(),

                        // Flight icon and dashed middle
                        Column(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: DashedLine(color: Colors.grey)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Transform.rotate(
                                          angle: 83.22, // The angle of rotation in radians (pi is 180 degrees)
                                          child: Icon(
                                            Icons.airplanemode_active,
                                            size: 18,
                                            color: Colors.purple,
                                          ),
                                        )
                                    ),
                                    Expanded(child: DashedLine(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(flightDuration,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black45)),
                          ],
                        ),

                        const Spacer(),

                        // To
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(toCode,
                                style: const TextStyle(
                                    color: Color(0xFF9B2CF3),
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            Text(toTime,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text(arrivalDate,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Passenger
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Passenger',
                            style:
                            TextStyle(color: Colors.black38, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(passengerName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Seat / Class / Gate
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoColumn(label: 'Seat', value: seat),
                        InfoColumn(label: 'Class', value: travelClass),
                        InfoColumn(label: 'Gate', value: gate),
                      ],
                    ),
                  ],
                ),
              ),

              // cut separator area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: const [
                    SizedBox(height: 18),
                    CutSeparator(),
                    SizedBox(height: 18),
                  ],
                ),
              ),

              // Barcode area
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                child: Column(
                  children: [
                    const Text('Scan this barcode!',
                        style: TextStyle(
                            color: Color(0xFF9B2CF3),
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),

                    // Barcode box
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SizedBox(
                          height: 82,
                          child: BarcodeWidget(
                            barcode: Barcode.code128(), // Code 128 format
                            data: barcodeData,        // Your barcode data
                            width: 300,
                            drawText: true,            // Show the number below the barcode
                          ),


                          // CustomPaint(
                          //   painter: BarcodePainter(),
                          // ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

}



// Small helper column used for Seat / Class / Gate
class InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  const InfoColumn({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.black38)),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ],
    );
  }
}

// Dashed line for the route center
class DashedLine extends StatelessWidget {
  final Color color;
  const DashedLine({super.key, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final dashCount = (constraints.maxWidth / 6).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dashCount, (_) {
          return Container(width: 3, height: 1.2, color: color);
        }),
      );
    });
  }
}
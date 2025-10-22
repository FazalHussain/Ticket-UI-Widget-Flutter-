import 'package:flight_ticket_booking_card/widget/ticket_clipper.dart';
import 'package:flight_ticket_booking_card/widget/ticket_painter.dart';
import 'package:flutter/material.dart';

/// {@template ticket_shape}
/// A widget that renders a **ticket-shaped container** with rounded corners and
/// circular side notches — similar to a physical boarding pass or event ticket.
///
/// This widget both **draws** the ticket outline (using [CustomPaint])
/// and **clips** its child widget to the same path, ensuring the content fits
/// perfectly within the ticket shape.
///
/// The ticket appearance is controlled by:
/// - [borderRadius] → Roundness of ticket corners.
/// - [notchRadius] → Radius of the circular notches on both sides.
/// - [notchOffsetFactor] → How much the notches are horizontally offset
///   (a factor of the notch radius).
/// - [borderColor] and [borderWidth] → Define the ticket border.
/// - [maxWidth] → Restricts how wide the ticket can be drawn.
///
/// Typically used to display structured information such as flight tickets,
/// concert passes, or coupon layouts.
///
/// Example usage:
///
/// ```dart
/// TicketShape(
///   borderColor: Colors.deepPurple,
///   child: Padding(
///     padding: const EdgeInsets.all(16),
///     child: Column(
///       mainAxisSize: MainAxisSize.min,
///       children: [
///         Text('Flight Ticket', style: Theme.of(context).textTheme.titleLarge),
///         const SizedBox(height: 8),
///         Text('Passenger: Jenny Simmons'),
///       ],
///     ),
///   ),
/// )
/// ```
///
/// This widget uses [TicketPainter] to draw the border and [TicketClipper]
/// to clip its child content to the ticket outline.
/// {@endtemplate}
class TicketShape extends StatelessWidget {
  /// The widget displayed inside the clipped ticket shape.
  final Widget child;

  /// Maximum width allowed for the ticket layout.
  final double maxWidth;

  /// Color of the ticket border.
  final Color borderColor;

  /// Corner radius of the ticket’s rounded rectangle.
  final double borderRadius;

  /// Radius of the circular side notches.
  final double notchRadius;

  /// Horizontal offset factor applied to the notch centers.
  ///
  /// A value of `0.2` means the notch centers are slightly shifted
  /// inward/outward to visually align with the curved corners.
  final double notchOffsetFactor;

  /// Thickness of the ticket border line.
  final double borderWidth;

  /// Creates a [TicketShape] widget that paints and clips content to
  /// a rounded ticket shape with matching border.
  const TicketShape({
    super.key,
    required this.child,
    this.maxWidth = 420,
    this.borderColor = Colors.purple,
    this.borderRadius = 18,
    this.notchRadius = 24,
    this.notchOffsetFactor = 0.2,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth == double.infinity
            ? maxWidth
            : constraints.maxWidth.clamp(0, maxWidth);

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width.toDouble()),
            child: CustomPaint(
              painter: TicketPainter(
                borderColor: borderColor,
                borderRadius: borderRadius,
                notchRadius: notchRadius,
                notchOffsetFactor: notchOffsetFactor,
                borderWidth: borderWidth,
              ),
              child: ClipPath(
                clipper: TicketClipper(
                  borderRadius: borderRadius,
                  notchRadius: notchRadius,
                  notchOffsetFactor: notchOffsetFactor,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
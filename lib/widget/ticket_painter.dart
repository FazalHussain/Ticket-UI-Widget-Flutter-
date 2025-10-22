import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// A [CustomPainter] that draws a ticket-shaped outline with optional border styling.
///
/// This painter creates a rectangular base shape with rounded corners and circular
/// notches (cutouts) on both left and right edges, commonly used for ticket,
/// coupon, or boarding pass UI components.
///
/// The painter supports both a filled background and an outer border stroke.
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   painter: _TicketPainter(
///     borderColor: Colors.grey.shade400,
///     borderRadius: 18,
///     notchRadius: 22,
///     notchOffsetFactor: 0.2,
///     borderWidth: 1.5,
///   ),
///   child: Container(
///     height: 200,
///     width: double.infinity,
///   ),
/// )
/// ```
class TicketPainter extends CustomPainter {
  /// The color used for the outer border stroke of the ticket.
  final Color borderColor;

  /// The radius applied to the ticket's rounded corners.
  ///
  /// Defaults are typically `18` to match [_TicketClipper] styles.
  final double borderRadius;

  /// The radius of the circular notches (cutouts) on both sides.
  ///
  /// Larger values produce deeper side cuts, while smaller values make
  /// the ticket edges more subtle.
  final double notchRadius;

  /// The offset factor that nudges the center of the circular notches slightly
  /// outside the main rectangle.
  ///
  /// This improves visual alignment between the circular cutouts and
  /// rounded corners.
  ///
  /// Defaults to `0.2`.
  final double notchOffsetFactor;

  /// The width of the border stroke outlining the ticket.
  final double borderWidth;

  /// Creates a new [_TicketPainter].
  ///
  /// All parameters are required to provide full customization of
  /// the ticket appearance.
  TicketPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.notchRadius,
    required this.notchOffsetFactor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define the main rectangular area for the ticket
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Create a base path with rounded corners
    final base = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

    // Define left and right circular notches slightly outside the rectangle
    final leftCircle = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(rect.left - notchRadius * notchOffsetFactor, rect.center.dy),
        radius: notchRadius,
      ));

    final rightCircle = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(rect.right + notchRadius * notchOffsetFactor, rect.center.dy),
        radius: notchRadius,
      ));

    // Subtract notches from the base rectangle to form the ticket shape
    var path = Path.combine(ui.PathOperation.difference, base, leftCircle);
    path = Path.combine(ui.PathOperation.difference, path, rightCircle);

    // Paint the ticket background (fill)
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Paint the border stroke
    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..isAntiAlias = true;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
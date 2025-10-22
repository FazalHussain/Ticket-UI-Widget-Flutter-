import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// A [CustomClipper] that creates a ticket-shaped clipping path.
///
/// The clipper produces a rectangular shape with rounded corners and
/// circular notches (cutouts) on both the left and right sides.
/// This is commonly used for ticket-like UI components (e.g., coupons, boarding passes, etc.).
///
/// Example usage:
/// ```dart
/// ClipPath(
///   clipper: TicketClipper(),
///   child: Container(
///     color: Colors.white,
///     height: 200,
///     width: double.infinity,
///   ),
/// )
/// ```
class TicketClipper extends CustomClipper<Path> {
  /// The radius of the ticket’s rounded corners.
  ///
  /// Defaults to `18`.
  final double borderRadius;

  /// The radius of the circular notches (cutouts) on both sides.
  ///
  /// Defaults to `22`.
  final double notchRadius;

  /// The offset factor that determines how much the notch circles are nudged
  /// outside the main rectangle boundary.
  ///
  /// This helps visually align the notches with the rounded corners.
  ///
  /// Defaults to `0.2`.
  final double notchOffsetFactor;

  /// Creates a new [TicketClipper].
  const TicketClipper({
    this.borderRadius = 18,
    this.notchRadius = 22,
    this.notchOffsetFactor = 0.2,
  });

  @override
  Path getClip(Size size) {
    // Define the main rectangle area of the ticket
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Base path with rounded corners
    final base = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

    // Create left and right circular notches slightly outside the rectangle
    final leftCircle = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(
          rect.left - notchRadius * notchOffsetFactor,
          rect.center.dy,
        ),
        radius: notchRadius,
      ));

    final rightCircle = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(
          rect.right + notchRadius * notchOffsetFactor,
          rect.center.dy,
        ),
        radius: notchRadius,
      ));

    // Subtract the notches from the base rectangle
    var p = Path.combine(ui.PathOperation.difference, base, leftCircle);
    p = Path.combine(ui.PathOperation.difference, p, rightCircle);

    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
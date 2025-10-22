import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// A simple [CustomPainter] that draws a barcode-like pattern of vertical bars.
///
/// Each bar has a specific width defined in the [widths] list,
/// with consistent spacing between bars. The entire barcode is centered
/// horizontally within the available canvas area.
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   size: Size(double.infinity, 60),
///   painter: BarcodePainter(),
/// )
/// ```
class BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint used for drawing each vertical bar (solid black fill)
    final paint = Paint()..color = Colors.black;

    // Predefined bar widths (the pattern of the barcode)
    final widths = <double>[
      2, 4, 2, 3, 6, 2, 2, 5, 3, 2, 4, 2,
      2, 6, 3, 2, 4, 2, 2, 3, 6, 2, 4, 2,
      3, 2, 5, 2, 2, 4, 3, 2, 6, 2, 3, 2,
    ];

    // Fixed spacing between each bar
    const spacing = 3.0;

    // Calculate the total width of all bars plus the spaces between them
    final totalWidth =
        widths.reduce((a, b) => a + b) + spacing * (widths.length - 1);

    // Compute the starting X position to horizontally center the barcode
    double x = (size.width - totalWidth) / 2;

    // Maximum height of each bar (fills available height)
    final maxBarHeight = size.height;

    // Draw each bar at the calculated position
    for (var w in widths) {
      canvas.drawRect(
        Rect.fromLTWH(x, 0, w, maxBarHeight),
        paint,
      );
      x += w + spacing; // Move to next bar position
    }
  }

  /// The painter does not depend on any dynamic data,
  /// so it never needs to repaint.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
import 'package:flutter/material.dart';

/// A horizontal dashed line separator, commonly used above a barcode section
/// or to visually divide content within a ticket-style layout.
///
/// This widget automatically adapts its dash count based on the available width,
/// ensuring an even, responsive dashed effect across all screen sizes.
///
/// Example:
/// ```dart
/// const CutSeparator()
/// ```
///
/// 💡 **Usage Tip:**
/// - Ideal for separating sections in travel tickets, receipts, or coupon UIs.
/// - You can customize the dash width, height, and color if needed.
class CutSeparator extends StatelessWidget {
  const CutSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate how many dashes can fit horizontally
        final count = (constraints.maxWidth / 8).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
                (_) => Container(
              width: 6,
              height: 1.8,
              color: Colors.grey.shade300,
            ),
          ),
        );
      },
    );
  }
}
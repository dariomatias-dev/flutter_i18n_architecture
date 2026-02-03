import 'package:flutter/material.dart';

class SectionHeaderWidget extends StatelessWidget {
  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleSize = 26.0,
    this.padding = const EdgeInsets.all(24.0),
    this.backgroundColor = Colors.white,
  });

  final String title;
  final String subtitle;
  final double titleSize;
  final EdgeInsets padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 15.0,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

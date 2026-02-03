import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.0),
        splashColor: Colors.black.withAlpha(5),
        highlightColor: Colors.black.withAlpha(3),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFE5E5E7), width: 1.0),
          ),
          child: Icon(icon, size: 24.0, color: const Color(0xFF8E8E93)),
        ),
      ),
    );
  }
}

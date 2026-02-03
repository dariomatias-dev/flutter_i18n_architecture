import 'package:flutter/material.dart';

class LanguageToggleWidget extends StatelessWidget {
  const LanguageToggleWidget({
    super.key,
    required this.currentLocale,
    required this.onChanged,
  });

  final String currentLocale;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEF),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ToggleOptionWidget(
            label: "EN",
            isSelected: currentLocale == 'en',
            onTap: () => onChanged('en'),
          ),
          ToggleOptionWidget(
            label: "PT",
            isSelected: currentLocale == 'pt',
            onTap: () => onChanged('pt'),
          ),
        ],
      ),
    );
  }
}

class ToggleOptionWidget extends StatelessWidget {
  const ToggleOptionWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}

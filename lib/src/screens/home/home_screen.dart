import 'package:flutter/material.dart';

import 'package:flutter_localization/l10n/app_localizations.dart';

import 'package:flutter_localization/src/shared/widgets/section_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SectionHeaderWidget(
            title: l10n.learningHeader,
            subtitle: l10n.learningSubheader,
            titleSize: 32.0,
            backgroundColor: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: <Widget>[
                EduCardWidget(
                  label: l10n.labelStatic,
                  content: l10n.exampleStatic,
                  color: const Color(0xFFE3F2FD),
                  icon: Icons.text_fields,
                ),
                const SizedBox(height: 16.0),
                EduCardWidget(
                  label: l10n.labelDynamic,
                  content: l10n.exampleDynamic('Flutter Dev'),
                  color: const Color(0xFFF3E5F5),
                  icon: Icons.unfold_more,
                ),
                const SizedBox(height: 16.0),
                EduCardWidget(
                  label: l10n.labelPlural,
                  content: l10n.examplePlural(_counter),
                  color: const Color(0xFFE8F5E9),
                  icon: Icons.exposure_plus_1,
                  onTap: () => setState(() => _counter++),
                ),
                const SizedBox(height: 40.0),
                Text(
                  l10n.instructionSwitch,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EduCardWidget extends StatelessWidget {
  const EduCardWidget({
    super.key,
    required this.label,
    required this.content,
    required this.icon,
    this.color = const Color(0xFFF5F5F7),
    this.onTap,
  });

  final String label;
  final String content;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1.0),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icon, size: 24.0, color: Colors.black87),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.add_circle_outline,
                color: Colors.grey,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }
}

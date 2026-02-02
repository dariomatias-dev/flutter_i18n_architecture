import 'package:flutter/material.dart';

import 'package:flutter_localization/l10n/app_localizations.dart';

import 'package:flutter_localization/src/providers/app_inherited_widget.dart';

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
    final appInherited = AppInheritedWidget.of(context)!;
    final currentLocale = appInherited.localeController.locale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          l10n.tutorialTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              spacing: 8.0,
              children: <Widget>[
                LanguageActionChipWidget(
                  label: 'EN',
                  isActive: currentLocale == 'en',
                  onTap: () => appInherited.localeController.changeLocale('en'),
                ),
                LanguageActionChipWidget(
                  label: 'PT',
                  isActive: currentLocale == 'pt',
                  onTap: () => appInherited.localeController.changeLocale('pt'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.learningHeader,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              l10n.learningSubheader,
              style: const TextStyle(
                fontSize: 16.0,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40.0),
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
              onTap: () {
                setState(() {
                  _counter++;
                });
              },
            ),
            const SizedBox(height: 40.0),
            Center(
              child: Text(
                l10n.instructionSwitch,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageActionChipWidget extends StatelessWidget {
  const LanguageActionChipWidget({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isActive ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}

class EduCardWidget extends StatelessWidget {
  const EduCardWidget({
    super.key,
    required this.label,
    required this.content,
    required this.color,
    required this.icon,
    this.onTap,
  });

  final String label;
  final String content;
  final Color color;
  final IconData icon;
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
          border: Border.all(color: const Color(0xFFEEEEEE)),
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

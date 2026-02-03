import 'package:flutter/material.dart';

import 'package:flutter_localization/l10n/l10n_messages.dart';

import 'package:flutter_localization/src/core/extensions/build_context_extension.dart';

import 'package:flutter_localization/src/providers/app_inherited_widget.dart';

class LocalizationService {
  LocalizedMessage getInitialState() => L10nMessages.stateInitial;

  LocalizedMessage performServiceAction() {
    return L10nMessages.msgServiceSuccess;
  }

  LocalizedMessage performRepositoryAction() {
    return L10nMessages.msgRepositoryError;
  }

  LocalizedMessage performDomainAction(int count) {
    return L10nMessages.examplePlural(count: count);
  }
}

class LocalizationScreen extends StatefulWidget {
  const LocalizationScreen({super.key});

  @override
  State<LocalizationScreen> createState() => LocalizationScreenState();
}

class LocalizationScreenState extends State<LocalizationScreen> {
  final service = LocalizationService();

  late LocalizedMessage messageIntent;

  int counter = 0;

  void handleServiceAction() {
    setState(() {
      messageIntent = service.performServiceAction();
    });
  }

  void handleRepositoryError() {
    setState(() {
      messageIntent = service.performRepositoryAction();
    });
  }

  void handleDomainUpdate() {
    setState(() {
      counter++;

      messageIntent = service.performDomainAction(counter);
    });
  }

  @override
  void initState() {
    super.initState();

    messageIntent = service.getInitialState();
  }

  @override
  Widget build(BuildContext context) {
    final localeController = AppInheritedWidget.of(context)!.localeController;

    final currentLocale = localeController.locale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          context.l10n(L10nMessages.tutorialTitle),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          LanguageToggle(
            currentLocale: currentLocale,
            onChanged: (String code) {
              localeController.changeLocale(code);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n(L10nMessages.learningHeader),
                  style: const TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  context.l10n(L10nMessages.learningSubheader),
                  style: const TextStyle(color: Colors.grey, height: 1.4),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.layers_outlined,
                  size: 48.0,
                  color: Color(0xFFD1D1D6),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: const Color(0xFFE5E5E7),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          context.l10n(L10nMessages.labelStatic).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          context.l10n(messageIntent),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 40.0),
            child: Column(
              children: <Widget>[
                Row(
                  spacing: 12.0,
                  children: <Widget>[
                    Expanded(
                      child: MinimalActionButton(
                        icon: Icons.auto_awesome_outlined,
                        onPressed: handleServiceAction,
                      ),
                    ),
                    Expanded(
                      child: MinimalActionButton(
                        icon: Icons.dns_outlined,
                        onPressed: handleRepositoryError,
                      ),
                    ),
                    Expanded(
                      child: MinimalActionButton(
                        icon: Icons.calculate_outlined,
                        onPressed: handleDomainUpdate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Text(
                  context.l10n(L10nMessages.instructionSwitch),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
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
        children: <Widget>[
          ToggleOption(
            label: "EN",
            isSelected: currentLocale == 'en',
            onTap: () => onChanged('en'),
          ),
          ToggleOption(
            label: "PT",
            isSelected: currentLocale == 'pt',
            onTap: () => onChanged('pt'),
          ),
        ],
      ),
    );
  }
}

class ToggleOption extends StatelessWidget {
  const ToggleOption({
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

class MinimalActionButton extends StatelessWidget {
  const MinimalActionButton({
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

import 'package:flutter/material.dart';

import 'package:flutter_localization/l10n/l10n_messages.dart';

import 'package:flutter_localization/src/core/extensions/build_context_extension.dart';

import 'package:flutter_localization/src/providers/app_inherited_widget.dart';

import 'package:flutter_localization/src/screens/home/home_screen.dart';
import 'package:flutter_localization/src/screens/localization/localization_service.dart';
import 'package:flutter_localization/src/screens/localization/widgets/action_button_widget.dart';

import 'package:flutter_localization/src/shared/widgets/language_toggle_widget.dart';
import 'package:flutter_localization/src/shared/widgets/section_header_widget.dart';

class LocalizationScreen extends StatefulWidget {
  const LocalizationScreen({super.key});

  @override
  State<LocalizationScreen> createState() => LocalizationScreenState();
}

class LocalizationScreenState extends State<LocalizationScreen> {
  final service = LocalizationService();

  late LocalizedMessage messageIntent;

  int counter = 0;

  void _handleAction(LocalizedMessage Function() action) {
    setState(() {
      messageIntent = action();
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
          LanguageToggleWidget(
            currentLocale: localeController.locale.languageCode,
            onChanged: (code) {
              localeController.changeLocale(code);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SectionHeaderWidget(
            title: context.l10n(L10nMessages.learningHeader),
            subtitle: context.l10n(L10nMessages.learningSubheader),
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
                  child: EduCardWidget(
                    label: context.l10n(L10nMessages.labelStatic),
                    content: context.l10n(messageIntent),
                    icon: Icons.api_outlined,
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
                      child: ActionButtonWidget(
                        icon: Icons.auto_awesome_outlined,
                        onPressed: () {
                          _handleAction(service.performServiceAction);
                        },
                      ),
                    ),
                    Expanded(
                      child: ActionButtonWidget(
                        icon: Icons.dns_outlined,
                        onPressed: () {
                          _handleAction(service.performRepositoryAction);
                        },
                      ),
                    ),
                    Expanded(
                      child: ActionButtonWidget(
                        icon: Icons.calculate_outlined,
                        onPressed: () {
                          counter++;

                          _handleAction(
                            () => service.performDomainAction(counter),
                          );
                        },
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

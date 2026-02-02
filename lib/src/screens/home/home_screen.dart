import 'package:flutter/material.dart';

import 'package:flutter_localization/l10n/app_localizations.dart';

import 'package:flutter_localization/src/providers/app_inherited_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appInheritedWidget = AppInheritedWidget.of(context)!;
    final currentLocale =
        appInheritedWidget.localeController.locale.languageCode;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(AppLocalizations.of(context)!.exampleStatic),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final newLocale = currentLocale == 'pt' ? 'en' : 'pt';

              appInheritedWidget.localeController.changeLocale(newLocale);
            },
            child: Text(
              currentLocale == 'pt'
                  ? 'Change to English'
                  : 'Mudar para Português',
            ),
          ),
        ],
      ),
    );
  }
}

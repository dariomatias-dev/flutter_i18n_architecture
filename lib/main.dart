import 'package:flutter/material.dart';

import 'package:flutter_localization/l10n/app_localizations.dart';

import 'package:flutter_localization/src/core/locale_controller.dart';

import 'package:flutter_localization/src/providers/app_inherited_widget.dart';

import 'package:flutter_localization/src/screens/home/home_screen.dart';

void main() {
  runApp(
    AppInheritedWidget(localeController: LocaleController(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = AppInheritedWidget.of(context)!.localeController;

    return ListenableBuilder(
      listenable: localeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Localization',
          debugShowCheckedModeBanner: false,
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const HomeScreen(),
        );
      },
    );
  }
}

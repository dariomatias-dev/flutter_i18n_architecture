import 'package:flutter/material.dart';

import 'package:flutter_localization/l10n/l10n_messages.dart';

import 'package:flutter_localization/src/core/extensions/build_context_extension.dart';

import 'package:flutter_localization/src/providers/app_inherited_widget.dart';

import 'package:flutter_localization/src/screens/home/home_screen.dart';
import 'package:flutter_localization/src/screens/localization/localization_screen.dart';

import 'package:flutter_localization/src/shared/widgets/language_toggle_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final screens = const <Widget>[HomeScreen(), LocalizationScreen()];

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
            fontSize: 18.0,
          ),
        ),
        actions: <Widget>[
          LanguageToggleWidget(
            currentLocale: currentLocale,
            onChanged: (code) => localeController.changeLocale(code),
          ),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE5E5E7), width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          backgroundColor: Colors.white,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color(0xFF8E8E93),
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.widgets_outlined),
              activeIcon: const Icon(Icons.widgets),
              label: 'Default',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_tree_outlined),
              activeIcon: const Icon(Icons.account_tree),
              label: 'Layers',
            ),
          ],
        ),
      ),
    );
  }
}

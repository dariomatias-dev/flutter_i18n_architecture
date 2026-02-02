import 'package:flutter/material.dart';
import 'package:flutter_localization/src/core/locale_controller.dart';

class AppInheritedWidget extends InheritedWidget {
  const AppInheritedWidget({
    super.key,
    required this.localeController,
    required super.child,
  });

  final LocaleController localeController;

  static AppInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppInheritedWidget>();
  }

  @override
  bool updateShouldNotify(AppInheritedWidget oldWidget) {
    return true;
  }
}

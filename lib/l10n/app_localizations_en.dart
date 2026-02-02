// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tutorialTitle => 'I18N GUIDE';

  @override
  String get learningHeader => 'Globalize your app.';

  @override
  String get learningSubheader =>
      'Demonstration of how the framework handles different types of translations.';

  @override
  String get labelStatic => 'Static Text';

  @override
  String get exampleStatic => 'This text is constant.';

  @override
  String get labelDynamic => 'Dynamic Value';

  @override
  String exampleDynamic(String name) {
    return 'Hello, $name!';
  }

  @override
  String get labelPlural => 'Pluralization';

  @override
  String examplePlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count interactions',
      one: 'One interaction',
      zero: 'No interactions',
    );
    return '$_temp0';
  }

  @override
  String get instructionSwitch =>
      'Tap the EN/PT buttons in the top bar to switch languages.';

  @override
  String get languageName => 'English';
}

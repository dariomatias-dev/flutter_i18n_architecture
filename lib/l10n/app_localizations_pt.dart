// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get tutorialTitle => 'GUIA I18N';

  @override
  String get learningHeader => 'Globalize seu app.';

  @override
  String get learningSubheader =>
      'Demonstração de como o framework gerencia diferentes tipos de traduções.';

  @override
  String get labelStatic => 'Texto Estático';

  @override
  String get exampleStatic => 'Este texto é constante.';

  @override
  String get labelDynamic => 'Valor Dinâmico';

  @override
  String exampleDynamic(String name) {
    return 'Olá, $name!';
  }

  @override
  String get labelPlural => 'Pluralização';

  @override
  String examplePlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count interações',
      one: 'Uma interação',
      zero: 'Nenhuma interação',
    );
    return '$_temp0';
  }

  @override
  String get instructionSwitch =>
      'Toque nos botões EN/PT na barra superior para trocar de idioma.';

  @override
  String get languageName => 'Português';
}

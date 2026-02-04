import 'package:flutter_i18n_architecture/l10n/app_localizations.dart';

typedef LocalizedMessage = String Function(AppLocalizations l10n);

abstract class L10nMessages {
  static LocalizedMessage get tutorialTitle =>
      (l10n) => l10n.tutorialTitle;

  static LocalizedMessage get learningHeader =>
      (l10n) => l10n.learningHeader;

  static LocalizedMessage get learningSubheader =>
      (l10n) => l10n.learningSubheader;

  static LocalizedMessage get labelStatic =>
      (l10n) => l10n.labelStatic;

  static LocalizedMessage get exampleStatic =>
      (l10n) => l10n.exampleStatic;

  static LocalizedMessage get labelDynamic =>
      (l10n) => l10n.labelDynamic;

  static LocalizedMessage exampleDynamic({required String name}) =>
      (l10n) => l10n.exampleDynamic(name);

  static LocalizedMessage get labelPlural =>
      (l10n) => l10n.labelPlural;

  static LocalizedMessage examplePlural({required int count}) =>
      (l10n) => l10n.examplePlural(count);

  static LocalizedMessage get instructionSwitch =>
      (l10n) => l10n.instructionSwitch;

  static LocalizedMessage get languageName =>
      (l10n) => l10n.languageName;

  static LocalizedMessage get stateInitial =>
      (l10n) => l10n.stateInitial;

  static LocalizedMessage get msgServiceSuccess =>
      (l10n) => l10n.msgServiceSuccess;

  static LocalizedMessage get msgRepositoryError =>
      (l10n) => l10n.msgRepositoryError;
}

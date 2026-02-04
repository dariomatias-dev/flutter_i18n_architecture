import 'package:flutter/widgets.dart';

import 'package:flutter_i18n_architecture/l10n/app_localizations.dart';

import 'package:flutter_i18n_architecture/l10n/l10n_messages.dart';

extension BuildContextExtension on BuildContext {
  String l10n(LocalizedMessage message) {
    final l10n = AppLocalizations.of(this);

    if (l10n == null) {
      throw FlutterError('AppLocalizations not found in context');
    }

    return message(l10n);
  }
}

import 'package:flutter_localization/l10n/l10n_messages.dart';

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

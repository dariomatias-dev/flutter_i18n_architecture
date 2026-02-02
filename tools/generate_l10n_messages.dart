import 'dart:convert';
import 'dart:io';

void main() {
  final arbFile = File('lib/l10n/app_en.arb');

  if (!arbFile.existsSync()) {
    throw Exception('app_en.arb not found');
  }

  final Map<String, dynamic> json = jsonDecode(arbFile.readAsStringSync());

  final buffer = StringBuffer()
    ..writeln(
      "import 'package:flutter_localization/l10n/app_localizations.dart';",
    )
    ..writeln()
    ..writeln(
      'typedef LocalizedMessage = String Function(AppLocalizations l10n);',
    )
    ..writeln()
    ..writeln('abstract class L10nMessages {')
    ..writeln();

  for (final entry in json.entries) {
    final key = entry.key;

    if (key.startsWith('@')) continue;

    final meta = json['@$key'] as Map<String, dynamic>?;

    if (meta == null || meta['placeholders'] == null) {
      buffer
        ..writeln('  static LocalizedMessage get $key => (l10n) => l10n.$key;')
        ..writeln();
      continue;
    }

    final placeholders = meta['placeholders'] as Map<String, dynamic>;

    buffer.writeln('  static LocalizedMessage $key({');

    for (final entry in placeholders.entries) {
      final name = entry.key;
      final type = _mapArbTypeToDart(entry.value['type'] as String?);

      buffer.writeln('    required $type $name,');
    }

    buffer.writeln('  }) =>');
    buffer
      ..writeln('      (l10n) => l10n.$key(${placeholders.keys.join(', ')});')
      ..writeln();
  }

  buffer.writeln('}');

  final output = File('lib/l10n/l10n_messages.dart');

  output.createSync(recursive: true);
  output.writeAsStringSync(buffer.toString());
}

String _mapArbTypeToDart(String? type) {
  switch (type) {
    case 'int':
      return 'int';
    case 'double':
      return 'double';
    case 'num':
      return 'num';
    case 'String':
    default:
      return 'String';
  }
}

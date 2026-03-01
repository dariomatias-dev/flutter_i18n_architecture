<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
</div>
<br>

<p align="center">
<strong>Language:</strong>
English | <a href="README.pt.md">Português</a>
</p>

<h1 align="center">Internationalization in Flutter with Layered Architecture</h1>

<p align="center">
An architectural approach to internationalization in Flutter based on separation of responsibilities, decoupling of layers, and controlled resolution of translations.
<br>
<a href="#context"><strong>Explore the documentation »</strong></a>
</p>

## Summary

- [Context](#context)
- [The Problem with Traditional Internationalization](#the-problem-with-traditional-internationalization)
- [Architectural Limitations](#architectural-limitations)
- [Architectural Solution](#architectural-solution)
- [Conceptual Flow](#conceptual-flow)
- [Core Concepts](#core-concepts)
- [Folder Structure](#folder-structure)
- [Usage in Practice](#usage-in-practice)
- [Automatic Message Generation](#automatic-message-generation)
- [Advantages and Trade-offs](#advantages-and-trade-offs)
- [Compatibility with the Official System](#compatibility-with-the-official-system)
- [License](#license)
- [Author](#author)

## Context

Internationalization in Flutter is officially supported through the `AppLocalizations` mechanism, accessed via `BuildContext`. This approach is appropriate when used **exclusively within the presentation layer**, where the widget tree context is available and valid.

However, in applications organized into layers, especially those aligned with principles such as **Clean Architecture**, **Onion Architecture**, or **Hexagonal Architecture**, the responsibility for deciding _which message should be displayed_ often belongs to domain or application layers rather than the UI layer.

When this occurs, the traditional model begins to introduce structural issues.

> **Note**</br>
> This documentation exclusively describes the **architecture of the internationalization solution**.</br>
> Flutter I18N configuration is not covered here.</br>
> For that topic, see:
> [https://github.com/dariomatias-dev/materials/blob/main/technologies/Flutter/internationalization.md](https://github.com/dariomatias-dev/materials/blob/main/technologies/Flutter/internationalization.md)

## The Problem with Traditional Internationalization

In Flutter, the standard use of internationalization is straightforward:

```dart
Text(
  AppLocalizations.of(context)!.welcomeMessage,
);
```

When restricted to the UI layer, it works correctly.

The issue arises when business decisions need to determine messages:

- Controllers
- Services
- Use cases
- Repositories

Common example:

```dart
class UserService {
  final BuildContext context;

  UserService(this.context);

  String resolveStatus({
    required User user,
  }) {
    if (user.isBlocked) {
      return AppLocalizations.of(context)!.userBlocked;
    }

    if (user.isActive) {
      return AppLocalizations.of(context)!.userActive;
    }

    return AppLocalizations.of(context)!.userInactive;
  }
}
```

## Architectural Limitations

This pattern generates several problems:

- `BuildContext` becomes a dependency of non-presentation layers;
- Domain logic becomes aware of infrastructure details;
- Services become coupled to the widget tree;
- Unit tests require localization setup;
- The `context` may be invalid or unavailable;
- Separation of responsibilities is broken.

The central issue is:

> Translation is being resolved outside the presentation layer.

This violates the fundamental principle that **dependencies must point inward**, not outward, as advocated by architectures such as Clean Architecture.

## Architectural Solution

The proposal of this solution is to completely separate:

- The **message decision**
- From the **translation resolution**

Lower layers do not return translated `String` values.
They return a **message intention**.

Translation occurs exclusively in the presentation layer, where:

- `BuildContext` is valid;
- The active language is known;
- Access to `AppLocalizations` is safe.

## Conceptual Flow

```
[Domain / Services]
        ↓
  LocalizedMessage
        ↓
[Presentation Layer]
        ↓
 AppLocalizations
        ↓
   Final String
```

#### Flow Logic

1. Lower layers return a message intention;
2. The intention does not contain translated text;
3. The presentation layer resolves the intention using `BuildContext`;
4. The final text is displayed according to the active language.

No layer outside the presentation layer accesses translations directly.

## Core Concepts

### LocalizedMessage

```dart
typedef LocalizedMessage = String Function(AppLocalizations l10n);
```

`LocalizedMessage` represents a **message intention**.

It defines how to obtain the localized text but does not execute the translation until `AppLocalizations` is provided.

This allows messages to be:

- Transported across layers;
- Tested without depending on localization;
- Resolved only at the appropriate moment.

### L10nMessages

```dart
abstract class L10nMessages {}
```

`L10nMessages` acts as a central catalog of intentions.

Example:

```dart
static LocalizedMessage get tutorialTitle =>
    (l10n) => l10n.tutorialTitle;
```

#### Dynamic message

```dart
static LocalizedMessage exampleDynamic({
  required String name,
}) =>
    (l10n) => l10n.exampleDynamic(name);
```

#### Pluralization

```dart
static LocalizedMessage examplePlural({
  required int count,
}) =>
    (l10n) => l10n.examplePlural(count);
```

## Folder Structure

```text
lib/
├─ l10n/
│  ├─ app_en.arb
│  ├─ app_pt.arb
│  ├─ app_localizations.dart
│  ├─ app_localizations_en.dart
│  ├─ app_localizations_pt.dart
│  └─ l10n_messages.dart
│
├─ src/
│  └─ core/
│     └─ extensions/
│        └─ build_context_extension.dart
│
tools/
└─ generate_l10n_messages.dart
```

## Usage in Practice

In the presentation layer:

```dart
Text(
  context.l10n(L10nMessages.tutorialTitle),
);
```

For dynamic messages:

```dart
context.l10n(
  L10nMessages.exampleDynamic(name: 'Dário'),
);
```

For pluralization:

```dart
context.l10n(
  L10nMessages.examplePlural(count: items.length),
);
```

## Automatic Message Generation

To prevent inconsistencies between `.arb` files and the intentions catalog (`L10nMessages`), the solution includes an **automatic code generation** process.

Manually maintaining the mapping between ARB keys and methods in `l10n_messages.dart` may lead to:

- Typographical errors;
- Divergence between key names and method names;
- Incorrect parameters in dynamic messages;
- Silent failures that only appear at runtime.

To eliminate this risk, a script transforms the base ARB file into a typed catalog of message intentions, ensuring structural alignment between translation and code.

### Script Execution

```bash
dart tools/generate_l10n_messages.dart
```

The script:

- Reads the base ARB file;
- Ignores metadata (`@key`);
- Identifies placeholders;
- Generates getters or methods as needed;
- Automatically maps types.

This guarantees full consistency between ARB and code.

## Advantages and Trade-offs

### Advantages

- Architectural isolation;
- Elimination of `BuildContext` dependency outside the UI;
- Improved testability;
- Explicit control over when translation occurs;
- Compatible with Clean Architecture;
- Strong typing.

### Trade-offs

- Slight increase in verbosity;
- Requires architectural discipline;
- May seem like overengineering for small applications;
- Introduces an intermediate abstraction layer.

## Compatibility with the Official System

This solution **does not replace Flutter’s official internationalization system**.

It fully utilizes:

- `AppLocalizations`
- `.arb` files
- Standard code generation

The proposal simply reorganizes how the official system is used architecturally, ensuring proper separation of responsibilities.

## License

Distributed under the **MIT License**.
See the [LICENSE](LICENSE) file.

## Author

Developed by **Dário Matias**:

- Portfolio: [https://dariomatias-dev.com](https://dariomatias-dev.com);
- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev);
- Email: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com);
- Instagram: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev);
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev).

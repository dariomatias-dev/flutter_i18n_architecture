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

<h1 align="center">Flutter Internationalization with Layered Architecture</h1>

<p align="center">
Architecture-oriented internationalization in Flutter, based on layer separation, responsibility decoupling, and controlled translation resolution.
<br>
<a href="#about-the-solution"><strong>Explore the documentation »</strong></a>
</p>

## Summary

- [About the Solution](#about-the-solution)
- [The Problem with Traditional Internationalization](#the-problem-with-traditional-internationalization)
- [The Core Idea of the Solution](#the-core-idea-of-the-solution)
- [Architecture and Responsibility Flow](#architecture-and-responsibility-flow)
- [Fundamental Concepts](#fundamental-concepts)
- [Folder Structure](#folder-structure)
- [Practical Usage](#practical-usage)
  - [Usage in the Presentation Layer](#usage-in-the-presentation-layer)
  - [Dynamic Messages](#dynamic-messages)
  - [Pluralization](#pluralization)
- [Automatic Message Generation](#automatic-message-generation)
- [License](#license)
- [Author](#author)

## About the Solution

This solution adopts an **architectural approach to internationalization in Flutter**, structuring the translation process into **well-defined layers** with **clearly separated responsibilities**. The focus is to eliminate direct coupling between the user interface and lower layers, treating translation as an infrastructure concern rather than a cross-cutting dependency of the application.

In conventional implementations, messages are retrieved directly via `AppLocalizations.of(context)`. This model requires the propagation of `BuildContext` beyond the presentation layer, resulting in improper dependencies in services, controllers, and domain layers. In addition to violating basic architectural principles, this pattern makes the code more fragile, since `context` may be unavailable or invalid outside the widget tree.

To solve this problem, the solution proposes a **message-intent-based flow**. Instead of requesting translated strings, lower layers return a **semantic representation of the message**, decoupled from language, format, and translation mechanism. The responsibility for converting this intent into a localized string is restricted to the correct point in the application, where the `BuildContext` exists and is valid.

As a result, the lower layers of the application **do not depend on context**, nor do they have knowledge of `AppLocalizations`, `.arb` files, or localization rules. They only return message intents, preserving architectural isolation and ensuring that translation is resolved in a controlled and predictable way in the presentation layer.

> **Note**</br>
> This documentation exclusively describes the **internationalization architecture solution**.</br>
> Flutter I18N configuration is not covered here.</br>
> For that topic, see:
> [https://github.com/dariomatias-dev/materials/blob/main/technologies/Flutter/internationalization.md](https://github.com/dariomatias-dev/materials/blob/main/technologies/Flutter/internationalization.md)

## Traditional Internationalization

In Flutter, internationalization **is applied directly in the presentation layer**, with translations being resolved during widget construction through `BuildContext`, which provides access to the framework’s native localization mechanism:

```dart
Text(
  AppLocalizations.of(context)!.welcomeMessage,
);
```

When restricted to the UI, this approach is functional and does not present issues.
The problem arises when the application evolves and **the decision about which message should be displayed no longer belongs exclusively to the presentation layer**.

In layered applications, it is common for business rules to determine states and outcomes in areas such as:

- Controllers;
- Services;
- Use cases;
- Repositories.

These layers are not part of the widget tree and exist to express **domain decisions**, not presentation details.
However, when attempting to reuse Flutter’s standard internationalization, translation ends up being forced into these layers.

A common example of this problem is the following:

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

This code clearly illustrates the problem with traditional internationalization when applied outside the presentation layer:

- `BuildContext` becomes a dependency of a non-presentation layer;
- Business logic becomes aware of presentation-layer details;
- The service becomes coupled to the widget tree;
- The code becomes fragile, as `context` may not exist or may be invalid;
- Unit tests start requiring context and localization configuration;
- Separation of responsibilities is broken.

The core point is: **translation is happening outside the presentation layer**.
Domain layers should not resolve translated text.

## The Core Idea of the Solution

The core idea of this solution is to **completely separate the message decision from its final translation**.

Lower layers of the application **do not access translations**.
They only pass a **message intent**.

This means that these layers:

- Do not know about `BuildContext`;
- Do not access `AppLocalizations`;
- Do not depend on the active language;
- Only return a **message intent**.

Translation happens exclusively in the presentation layer, where:

- `BuildContext` is valid;
- The current language is known;
- Access to `AppLocalizations` is safe.

This change ensures that each layer fulfills only its own responsibility.

## Architecture and Responsibility Flow

The solution is organized into layers with well-defined responsibilities:

```
UI
└─ BuildContext Extension
└─ L10nMessages
└─ AppLocalizations (generated by Flutter)
└─ ARB Files
```

In this model:

- Domain layers decide **which message makes sense**;
- The message is represented by an abstraction (`LocalizedMessage`);
- The presentation layer resolves this abstraction into text at the correct moment.

### Conceptual flow

1. Lower layers return or expose a **message intent**;
2. This intent does not contain translated text;
3. The presentation layer receives the intent and resolves the translation using `BuildContext`;
4. The final text is displayed according to the active language.

At no point do layers outside the presentation layer access translations directly.

## Fundamental Concepts

### LocalizedMessage

```dart
typedef LocalizedMessage = String Function(AppLocalizations l10n);
```

`LocalizedMessage` represents a **message intent**.

It does not contain translated text, only the rule for obtaining it when `AppLocalizations` is available.

This allows messages to be:

- Defined outside the presentation layer;
- Transported across layers;
- Resolved only at display time.

### L10nMessages

```dart
abstract class L10nMessages {}
```

`L10nMessages` acts as a **central catalog of message intents** for the application.

Each entry:

- Has a semantic name;
- Represents a clear intent;
- Directly maps to ARB keys;
- Can be static or parameterized.

Example:

```dart
static LocalizedMessage get tutorialTitle =>
    (l10n) => l10n.tutorialTitle;
```

## Folder Structure

```text
lib/
 ├─ l10n/
 │   ├─ app_en.arb
 │   ├─ app_localizations_en.dart
 │   ├─ app_localizations_pt.dart
 │   ├─ app_localizations.dart
 │   ├─ app_pt.arb
 │   └─ l10n_messages.dart
 │
 ├─ src/
 │   └─ core/
 │       └─ extensions/
 │           └─ build_context_extension.dart
 │
tools/
 └─ generate_l10n_messages.dart
```

## Practical Usage

### Usage in the Presentation Layer

Message intent resolution happens exclusively in the presentation layer:

```dart
Text(
  context.l10n(L10nMessages.tutorialTitle),
);
```

No other layer needs `BuildContext`.

### Dynamic Messages

```dart
static LocalizedMessage exampleDynamic({
  required String name,
}) =>
    (l10n) => l10n.exampleDynamic(name);
```

Usage:

```dart
context.l10n(
  L10nMessages.exampleDynamic(name: 'Dário'),
);
```

### Pluralization

```dart
static LocalizedMessage examplePlural({
  required int count,
}) =>
    (l10n) => l10n.examplePlural(count);
```

Usage:

```dart
context.l10n(
  L10nMessages.examplePlural(count: items.length),
);
```

## Automatic Message Generation

The solution includes a script responsible for automatically generating the `l10n_messages.dart` file from the ARB:

```bash
dart tools/generate_l10n_messages.dart
```

The script:

- Reads the base ARB;
- Ignores metadata (`@key`);
- Identifies placeholders;
- Generates getters or methods as needed;
- Automatically maps types.

This ensures full consistency between ARB and code.

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

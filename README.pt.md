<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
</div>
<br>

<p align="center">
<strong>Language:</strong>
<a href="README.md">English</a> | Português
</p>

<h1 align="center">Internacionalização em Flutter com Arquitetura em Camadas</h1>

<p align="center">
Internacionalização em Flutter orientada à arquitetura, baseada na separação em camadas, desacoplamento de responsabilidades e resolução controlada de traduções.
<br>
<a href="#sobre-a-solução"><strong>Explore a documentação »</strong></a>
</p>

## Sumário

- [Sobre a Solução](#sobre-a-solução)
- [O Problema da Internacionalização Tradicional](#o-problema-da-internacionalização-tradicional)
- [A Ideia Central da Solução](#a-ideia-central-da-solução)
- [Arquitetura e Fluxo de Responsabilidades](#arquitetura-e-fluxo-de-responsabilidades)
- [Conceitos Fundamentais](#conceitos-fundamentais)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Uso na Prática](#uso-na-prática)
  - [Uso na Camada de Apresentação](#uso-na-camada-de-apresentação)
  - [Mensagens Dinâmicas](#mensagens-dinâmicas)
  - [Pluralização](#pluralização)
- [Geração Automática de Mensagens](#geração-automática-de-mensagens)
- [Licença](#licença)
- [Autor](#autor)

## Sobre a Solução

Esta solução adota uma abordagem **arquitetural para internacionalização em Flutter**, estruturando o processo de tradução em **camadas bem definidas** e com **responsabilidades claramente separadas**. O foco é eliminar o acoplamento direto entre a interface de usuário e as camadas inferiores, tratando a tradução como uma preocupação de infraestrutura, e não como uma dependência transversal da aplicação.

Em implementações convencionais, mensagens são obtidas diretamente por meio de `AppLocalizations.of(context)`. Esse modelo exige a propagação do `BuildContext` para além da camada de apresentação, o que resulta em dependências indevidas em serviços, controladores e camadas de domínio. Além de violar princípios básicos de arquitetura, esse padrão torna o código mais frágil, visto que o `context` pode estar indisponível ou inválido fora da árvore de widgets.

Para resolver esse problema, a solução propõe um **fluxo baseado em intenção de mensagem**. Em vez de requisitar strings traduzidas, as camadas inferiores retornam uma **representação semântica da mensagem**, desacoplada de idioma, formato e mecanismo de tradução. A responsabilidade de converter essa intenção em uma string localizada é restrita ao ponto correto da aplicação, onde o `BuildContext` existe e é válido.

Com isso, as camadas inferiores da aplicação **não dependem de contexto**, nem possuem conhecimento sobre `AppLocalizations`, arquivos `.arb` ou regras de localização. Elas apenas retornam intenções de mensagem, preservando isolamento arquitetural e garantindo que a tradução seja resolvida de forma controlada e previsível na camada de apresentação.

> **Observação**</br>
> Esta documentação descreve exclusivamente a **arquitetura da solução de internacionalização**.</br>
> A configuração de I18N em Flutter não é abordada aqui.</br>
> Para esse tema, consulte:
> [https://github.com/dariomatias-dev/materials/blob/main/technologies/Flutter/internationalization.md](https://github.com/dariomatias-dev/materials/blob/main/technologies/Flutter/internationalization.md)

## Internacionalização Tradicional

Em Flutter, a internacionalização **é aplicada diretamente na camada de apresentação**, com as traduções sendo resolvidas durante a construção dos widgets por meio do `BuildContext`, que fornece acesso ao mecanismo nativo de localização do framework:

```dart
Text(
  AppLocalizations.of(context)!.welcomeMessage,
);
```

Enquanto restrito à interface, ele é funcional e não apresenta problemas.
O problema surge quando a aplicação evolui e **a decisão sobre qual mensagem deve ser exibida deixa de pertencer exclusivamente à camada de apresentação**.

Em aplicações organizadas por camadas, é comum que regras de negócio determinem estados e resultados em pontos como:

- Controllers;
- Services;
- Use cases;
- Repositories.

Essas camadas não fazem parte da árvore de widgets e existem para expressar **decisões de domínio**, não detalhes de apresentação.
No entanto, ao tentar reutilizar a internacionalização padrão do Flutter, acaba-se forçando a tradução para dentro dessas camadas.

Um exemplo comum desse problema é o seguinte:

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

Esse código ilustra claramente o problema da internacionalização tradicional quando aplicada fora da camada de apresentação:

- O `BuildContext` passa a ser uma dependência de uma camada que não é de apresentação;
- A lógica de negócio passa a conhecer detalhes da camada de apresentação;
- O service se torna acoplado à árvore de widgets;
- O código se torna frágil, pois o `context` pode não existir ou estar inválido;
- Testes unitários passam a exigir contexto e configuração de internacionalização;
- A separação de responsabilidades é quebrada.

O ponto central é: **a tradução está acontecendo fora da camada de apresentação**.
Camadas de domínio não deveriam resolver texto traduzido.

## Ideia Central da Solução

A ideia central desta solução é **separar completamente a decisão da mensagem da sua tradução final**.

Camadas inferiores da aplicação **não acessam traduções**.
Elas apenas passam uma **intenção de mensagem**.

Isso significa que essas camadas:

- Não conhecem `BuildContext`;
- Não acessam `AppLocalizations`;
- Não dependem do idioma ativo;
- Apenas retornam uma **intenção de mensagem**.

A tradução acontece exclusivamente na camada de apresentação, onde:

- O `BuildContext` é válido;
- O idioma atual é conhecido;
- O acesso ao `AppLocalizations` é seguro.

Essa mudança garante que cada camada cumpra apenas sua responsabilidade.

## Arquitetura e Fluxo de Responsabilidades

A solução é organizada em camadas com responsabilidades bem definidas:

```
UI
└─ BuildContext Extension
└─ L10nMessages
└─ AppLocalizations (gerado pelo Flutter)
└─ ARB Files
```

Nesse modelo:

- Camadas de domínio decidem **qual mensagem faz sentido**;
- A mensagem é representada por uma abstração (`LocalizedMessage`);
- A camada de apresentação resolve essa abstração em texto no momento correto.

### Fluxo conceitual

1. Camadas inferiores retornam ou expõem uma **intenção de mensagem**;
2. Essa intenção não contém texto traduzido;
4. A camada de apresentação recebe a intenção e resolve a tradução utilizando o `BuildContext`;
5. O texto final é exibido conforme o idioma ativo.

Em nenhum momento camadas fora da camada de apresentação acessam traduções diretamente.

## Conceitos Fundamentais

### LocalizedMessage

```dart
typedef LocalizedMessage = String Function(AppLocalizations l10n);
```

`LocalizedMessage` representa uma **intenção de mensagem**.

Ela não contém o texto traduzido, apenas a regra de como obtê-lo quando o `AppLocalizations` estiver disponível.

Isso permite que mensagens sejam:

- Definidas fora da camada de apresentação;
- Transportadas entre camadas;
- Resolvidas apenas no momento de exibição.

### L10nMessages

```dart
abstract class L10nMessages {}
```

`L10nMessages` atua como um **catálogo central de intenções de mensagens** da aplicação.

Cada entrada:

- Possui um nome semântico;
- Representa uma intenção clara;
- Mapeia diretamente as chaves do ARB;
- Pode ser estática ou parametrizada.

Exemplo:

```dart
static LocalizedMessage get tutorialTitle =>
    (l10n) => l10n.tutorialTitle;
```

## Estrutura de Pastas

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

## Uso na Prática

### Uso na Camada de Apresentação

A resolução da intenção de mensagem acontece exclusivamente na camada de apresentação:

```dart
Text(
  context.l10n(L10nMessages.tutorialTitle),
);
```

Nenhuma outra camada precisa de `BuildContext`.

### Mensagens Dinâmicas

```dart
static LocalizedMessage exampleDynamic({
  required String name,
}) =>
    (l10n) => l10n.exampleDynamic(name);
```

Uso:

```dart
context.l10n(
  L10nMessages.exampleDynamic(name: 'Dário'),
);
```

### Pluralização

```dart
static LocalizedMessage examplePlural({
  required int count,
}) =>
    (l10n) => l10n.examplePlural(count);
```

Uso:

```dart
context.l10n(
  L10nMessages.examplePlural(count: items.length),
);
```

## Geração Automática de Mensagens

A solução inclui um script responsável por gerar automaticamente o arquivo `l10n_messages.dart` a partir do ARB:

```bash
dart tools/generate_l10n_messages.dart
```

O script:

- Lê o ARB base;
- Ignora metadados (`@key`);
- Identifica placeholders;
- Gera getters ou métodos conforme necessário;
- Mapeia tipos automaticamente.

Isso garante consistência total entre ARB e código.

## Licença

Distribuído sob a **Licença MIT**.
Veja o arquivo [LICENSE](LICENSE).

## Autor

Desenvolvido por **Dário Matias**:

- Portfolio: [https://dariomatias-dev.com](https://dariomatias-dev.com);
- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev);
- Email: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com);
- Instagram: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev);
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev).

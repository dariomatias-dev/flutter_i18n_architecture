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
Uma abordagem arquitetural para internacionalização em Flutter baseada em separação de responsabilidades, desacoplamento de camadas e resolução controlada de traduções.
<br>
<a href="#sobre-a-solução"><strong>Explore a documentação »</strong></a>
</p>

## Sumário

- [Contexto](#contexto)
- [O Problema da Internacionalização Tradicional](#o-problema-da-internacionalização-tradicional)
- [Limitações Arquiteturais](#limitações-arquiteturais)
- [Solução Arquitetural](#solução-arquitetural)
- [Fluxo Conceitual](#fluxo-conceitual)
- [Conceitos Fundamentais](#conceitos-fundamentais)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Uso na Prática](#uso-na-prática)
- [Geração Automática de Mensagens](#geração-automática-de-mensagens)
- [Vantagens e Trade-offs](#vantagens-e-trade-offs)
- [Compatibilidade com o Sistema Oficial](#compatibilidade-com-o-sistema-oficial)
- [Licença](#licença)
- [Autor](#autor)

## Contexto

A internacionalização em Flutter é oficialmente suportada pelo mecanismo de `AppLocalizations`, acessado por meio do `BuildContext`. Essa abordagem é adequada quando utilizada **exclusivamente na camada de apresentação**, onde o contexto da árvore de widgets está disponível e válido.

Entretanto, em aplicações organizadas por camadas, especialmente aquelas alinhadas a princípios como **Clean Architecture**, **Onion Architecture** ou **Hexagonal Architecture**, a responsabilidade por decidir _qual mensagem deve ser exibida_ frequentemente pertence a camadas de domínio ou aplicação, e não à camada de interface.

Quando isso ocorre, o modelo tradicional começa a introduzir problemas estruturais.

> **Observação**</br>
> Esta documentação descreve exclusivamente a **arquitetura da solução de internacionalização**.</br>
> A configuração de I18N em Flutter não é abordada aqui.</br>
> Para esse tema, consulte:
> [https://github.com/dariomatias-dev/materials/blob/main/technologies/Flutter/internationalization.md](https://github.com/dariomatias-dev/materials/blob/main/technologies/Flutter/internationalization.md)

## O Problema da Internacionalização Tradicional

No Flutter, o uso padrão da internacionalização é direto:

```dart
Text(
  AppLocalizations.of(context)!.welcomeMessage,
);
```

Enquanto restrito à interface, funciona corretamente.

O problema surge quando decisões de negócio precisam determinar mensagens:

- Controllers
- Services
- Use cases
- Repositories

Exemplo comum:

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

## Limitações Arquiteturais

Esse padrão gera diversos problemas:

- `BuildContext` se torna dependência de camadas que não são de apresentação;
- Lógica de domínio passa a conhecer detalhes de infraestrutura;
- Services tornam-se acoplados à árvore de widgets;
- Testes unitários exigem configuração de localização;
- O `context` pode estar inválido ou inexistente;
- A separação de responsabilidades é quebrada.

O ponto central é:

> A tradução está sendo resolvida fora da camada de apresentação.

Isso viola o princípio fundamental de que **dependências devem apontar para dentro**, não para fora, como defendido por arquiteturas como Clean Architecture.

## Solução Arquitetural

A proposta desta solução é separar completamente:

- A **decisão da mensagem**
- Da **resolução da tradução**

Camadas inferiores não retornam `String` traduzida.
Elas retornam uma **intenção de mensagem**.

A tradução acontece exclusivamente na camada de apresentação, onde:

- O `BuildContext` é válido;
- O idioma ativo é conhecido;
- O acesso ao `AppLocalizations` é seguro.

## Fluxo Conceitual

```
[Domain / Services]
        ↓
  LocalizedMessage
        ↓
[Presentation Layer]
        ↓
 AppLocalizations
        ↓
   String final
```

#### Lógica do Fluxo

1. Camadas inferiores retornam uma intenção de mensagem;
2. Essa intenção não contém texto traduzido;
3. A camada de apresentação resolve a intenção utilizando o `BuildContext`;
4. O texto final é exibido conforme o idioma ativo.

Nenhuma camada fora da apresentação acessa traduções diretamente.

## Conceitos Fundamentais

### LocalizedMessage

```dart
typedef LocalizedMessage = String Function(AppLocalizations l10n);
```

`LocalizedMessage` representa uma **intenção de mensagem**.

Ela define como obter o texto localizado, mas não executa a tradução até que `AppLocalizations` seja fornecido.

Isso permite que mensagens sejam:

- Transportadas entre camadas;
- Testadas sem depender de localização;
- Resolvidas apenas no momento correto.

### L10nMessages

```dart
abstract class L10nMessages {}
```

`L10nMessages` atua como um catálogo central de intenções.

Exemplo:

```dart
static LocalizedMessage get tutorialTitle =>
    (l10n) => l10n.tutorialTitle;
```

#### Mensagem dinâmica

```dart
static LocalizedMessage exampleDynamic({
  required String name,
}) =>
    (l10n) => l10n.exampleDynamic(name);
```

#### Pluralização

```dart
static LocalizedMessage examplePlural({
  required int count,
}) =>
    (l10n) => l10n.examplePlural(count);
```

## Estrutura de Pastas

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

## Uso na Prática

Na camada de apresentação:

```dart
Text(
  context.l10n(L10nMessages.tutorialTitle),
);
```

Para mensagens dinâmicas:

```dart
context.l10n(
  L10nMessages.exampleDynamic(name: 'Dário'),
);
```

Para pluralização:

```dart
context.l10n(
  L10nMessages.examplePlural(count: items.length),
);
```

## Geração Automática de Mensagens

Para evitar inconsistências entre os arquivos `.arb` e o catálogo de intenções (`L10nMessages`), a solução inclui um processo de **geração automática de código**.

Manter manualmente o mapeamento entre chaves do ARB e métodos em `l10n_messages.dart` pode gerar:

- Erros de digitação;
- Divergência entre nomes de chaves e métodos;
- Parâmetros incorretos em mensagens dinâmicas;
- Falhas silenciosas que só aparecem em tempo de execução.

Para eliminar esse risco, um script é responsável por transformar o ARB base em um catálogo tipado de intenções de mensagem, garantindo alinhamento estrutural entre tradução e código.

### Execução do Script

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

## Vantagens e Trade-offs

### Vantagens

- Isolamento arquitetural;
- Eliminação de dependência de `BuildContext` fora da UI;
- Maior testabilidade;
- Controle explícito do momento de tradução;
- Compatível com Clean Architecture;
- Forte tipagem.

### Trade-offs

- Leve aumento de verbosidade;
- Exige disciplina arquitetural;
- Pode parecer overengineering para aplicações pequenas;
- Introduz camada intermediária de abstração.

## Compatibilidade com o Sistema Oficial

Esta solução **não substitui o sistema oficial de internacionalização do Flutter**.

Ela utiliza integralmente:

- `AppLocalizations`
- Arquivos `.arb`
- Geração padrão de código

A proposta apenas reorganiza arquiteturalmente o uso do sistema oficial, garantindo separação adequada de responsabilidades.

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

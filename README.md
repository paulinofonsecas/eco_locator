# Eco Locator

Um aplicativo Flutter para localizar pontos de reciclagem próximos à sua localização.

## Visão Geral

O Eco Locator é uma solução sustentável que ajuda usuários a encontrar pontos de reciclagem em sua região, facilitando o descarte consciente de materiais recicláveis.

## 🏗️ Arquitetura

O projeto implementa Clean Architecture com Provider para gerenciamento de estado. A estrutura está organizada da seguinte forma:

```
lib/
├── app/              # Configuração do aplicativo
├── core/             # Componentes compartilhados e design system
└── features/         # Módulos da aplicação
    └── locator/      # Feature principal de localização
        ├── data/     # Implementações de repositórios
        ├── domain/   # Regras de negócio e casos de uso
        └── presentation/  # UI e gerenciamento de estado
```

### Camadas da Arquitetura

#### 1. Domain Layer
- Casos de uso (GetRecyclingPointsUseCase, CalculateDistanceUseCase)
- Interfaces de repositórios (IRecyclingPointRepository)
- Entidades do domínio

#### 2. Data Layer
- Implementações de repositórios
- Models
- Fonte de dados

#### 3. Presentation Layer
- Pages (EcoLocatorScreen)
- Providers (EcoLocatorProvider)
- Widgets reutilizáveis

### Gerenciamento de Estado

O projeto utiliza Provider como solução de gerenciamento de estado, oferecendo:
- Gerenciamento eficiente de estado
- Injeção de dependências
- Separação clara de responsabilidades
- Facilidade de teste

## 📱 Download do APK

Baixe a versão mais recente do aplicativo:

[Download APK v1.0.0](https://github.com/paulinofonsecas/eco_locator/releases/latest) <!-- Atualize este link quando disponibilizar o APK -->

## 🚀 Como Executar o Projeto

### Pré-requisitos

- Flutter SDK (versão mais recente)
- Android Studio ou VS Code
- Git

### Configuração do Ambiente

1. Clone o repositório:
   ```bash
   git clone https://github.com/paulinofonsecas/eco_locator.git
   ```

2. Entre na pasta do projeto:
   ```bash
   cd eco_locator
   ```

3. Configure as variáveis de ambiente:
   - Crie um arquivo `.env` na raiz do projeto
   - Adicione as seguintes variáveis:
     ```env
     APP_NAME=eco_locator
     ```

4. Instale as dependências:
   ```bash
   flutter pub get
   ```

5. Execute o projeto:
   ```bash
   flutter run
   ```

## Development Guidelines

### Code Style

- Follow Flutter's official style guide
- Use meaningful variable and function names
- Write comments for complex logic
- Keep files and classes focused and small

### Architecture Guidelines

- Follow the Clean Architecture pattern
- Maintain separation of concerns
- Write unit tests for business logic
- Document complex implementations

### State Management

- Use Provider for state management
- Follow best practices for chosen solution
- Maintain clear state update patterns
- Document state flow for complex features

## Testing

```bash
# Run all tests
flutter test

```

## Building for Production

```bash
# Build APK
flutter build apk

# Build iOS
flutter build ios
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.


[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[flutter_bunny_cli_link]: https://www.flutterbunny.xyz/
[flutter_bunny_cli_guide_link]: https://www.flutterbunny.xyz/set_up_guide/
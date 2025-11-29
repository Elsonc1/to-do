# To-Do Mobile App

Aplicativo mobile desenvolvido com Flutter para gestão de tarefas.

## Tecnologias Utilizadas

- **Flutter** - Framework multiplataforma para desenvolvimento mobile
- **Dart** - Linguagem de programação
- **HTTP** - Cliente HTTP para comunicação com a API

## Estrutura do Projeto

```
mobile/
├── lib/
│   ├── models/
│   │   └── task.dart
│   ├── services/
│   │   └── task_service.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── task_form_screen.dart
│   ├── widgets/
│   │   └── task_card.dart
│   └── main.dart
└── pubspec.yaml
```

## Instalação e Configuração

### Pré-requisitos

- Flutter SDK (versão 3.0 ou superior)
- Android Studio / Xcode (apenas se quiser usar emulador)
- **OU** Google Chrome (para testar no navegador - mais fácil!)

**Dica:** Você pode testar no navegador sem instalar Android Studio! Consulte [RUN_WITHOUT_ANDROID_STUDIO.md](./RUN_WITHOUT_ANDROID_STUDIO.md)

### Configuração

1. **Navegue até a pasta do mobile:**
   ```bash
   cd mobile
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure a URL da API:**
   
   Edite o arquivo `lib/services/task_service.dart` e ajuste a URL base:
   
   ```dart
   static const String baseUrl = 'http://10.0.2.2:3000';
   ```
   
   **Importante:** 
   - Android Emulator: use `10.0.2.2` para acessar o localhost
   - iOS Simulator: use `localhost` 
   - Dispositivo físico: use o IP da sua máquina na rede local

4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

## Funcionalidades

- Listagem de tarefas
- Cadastro de novas tarefas
- Edição de tarefas existentes
- Alteração de status (pendente, em andamento, concluída)
- Exclusão de tarefas
- Filtros por status
- Pull-to-refresh

## Comandos Úteis

- `flutter pub get` - Instala as dependências
- `flutter run` - Executa o aplicativo
- `flutter build apk` - Gera APK para Android
- `flutter build ios` - Gera build para iOS
- `flutter clean` - Limpa o projeto

## Observações

- Certifique-se de que o backend está rodando e acessível antes de iniciar o app
- Para dispositivos físicos, você precisa estar na mesma rede Wi-Fi e usar o IP local da máquina onde o backend está rodando
- O aplicativo foi desenvolvido sem Docker conforme especificado nos requisitos

## Configuração da URL da API

A URL da API é configurada no arquivo `lib/services/task_service.dart`. Dependendo do ambiente, use:

- **Android Emulator:** `http://10.0.2.2:3000`
- **iOS Simulator:** `http://localhost:3000`
- **Dispositivo Físico:** `http://SEU_IP_LOCAL:3000` (ex: `http://192.168.1.100:3000`)

Para descobrir seu IP local:
- **Windows:** `ipconfig` (procure por IPv4)
- **Mac/Linux:** `ifconfig` ou `ip addr show`


# Loomi Streaming

O **Loomi Streaming** é uma solução ofertada pela Loomi

## Requisitos

Para rodar o projeto, é necessário ter instalado:
- [Flutter 3.19.6](https://flutter.dev/docs/get-started/install) (versão compatível)
- [Dart 3.3.4](https://dart.dev/get-dart)
- Emulador ou dispositivo físico com modo de desenvolvedor

## Como Rodar o Projeto

1. Clone o repositório:
   ```sh
   git clone https://github.com/Kauanny-cmd/loomi-streaming
   ```
2. Acesse o diretório do projeto:
   ```sh
   cd loomi-streaming
   ```
3. Instale as dependências do projeto:
   ```sh
   flutter pub get
   ```
4. Execute o projeto:
   ```sh
   flutter run
   ```
    - Para rodar no emulador, certifique-se de que um dispositivo virtual esteja ativo.
    - Para rodar no dispositivo físico, conecte o aparelho via USB e ative a depuração USB.

## Debug

Caso precise rodar o projeto em modo debug:
```sh
flutter run --debug
```

Se houver problemas com dependências:
```sh
flutter clean
flutter pub get
```
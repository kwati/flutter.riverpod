import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class StateObverser extends ProviderObserver {
  final _log = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 4,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _log.i('$newValue');
  }
}

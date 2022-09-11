import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khalti_riverpod/src/base/base_state.dart';

class PageProvider<S extends BaseState> extends StateNotifier<S> {
  void Function(S state)? _listener;
  BuildContext? _context;

  PageProvider(super.state);

  void rebuildWith(BaseState newState) {
    state = newState as S;
    _invokeListener();
  }

  void _invokeListener() {
    _listener?.call(state);
  }

  // TODO(ashim) need to refactor progress dialog code
  void setProgressDialog(String? message, {bool dismissible = false}) {
    if (message == null) {
      if (_context != null) Navigator.pop(_context!);
    } else {
      if (_context != null) {
        showDialog(
          barrierDismissible: dismissible,
          context: _context!,
          builder: (context) => WillPopScope(
            onWillPop: () async => dismissible,
            child: Dialog(
              child: Text(message),
            ),
          ),
        );
      }
    }
  }

  bool _onReadyCalled = false;
}

// ============================================== BasePage ======================================================

abstract class _BasePage<T extends PageProvider<S>, S extends BaseState> extends ConsumerStatefulWidget {
  const _BasePage({
    super.key,
    required this.builder,
    this.onReady,
    this.onDispose,
    this.initState,
    this.listener,
  });

  final VoidCallback? onReady;
  final VoidCallback? initState;
  final VoidCallback? onDispose;
  final Widget Function(BuildContext context, T provider, S state) builder;
  final void Function(BuildContext context, T provider, S state)? listener;
}

// ============================================== Normal BasePage ======================================================

class BasePage<T extends PageProvider<S>, S extends BaseState> extends _BasePage<T, S> {
  const BasePage({
    super.key,
    required this.provider,
    required super.builder,
    super.listener,
    super.onReady,
    super.initState,
    super.onDispose,
  });

  final StateNotifierProvider<T, S> provider;

  @override
  ConsumerState<BasePage<T, S>> createState() => _BasePageState();
}

class _BasePageState<T extends PageProvider<S>, S extends BaseState> extends ConsumerState<BasePage<T, S>> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _createPageModel();
    });
    super.initState();
  }

  void _createPageModel() {
    final pageProvider = ref.read(widget.provider.notifier);
    pageProvider._listener = (state) => widget.listener?.call(context, pageProvider, state);
    pageProvider._context = context;

    if (widget.initState != null) {
      if (pageProvider._onReadyCalled) {
        widget.initState!();
      }
    }

    if (widget.onReady != null) {
      if (!pageProvider._onReadyCalled) {
        widget.onReady!();
        pageProvider._onReadyCalled = true;
      } else {
        widget.onReady!();
      }
    }
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageModel = ref.watch(widget.provider.notifier);
    final pageState = ref.watch(widget.provider);

    return widget.builder(context, pageModel, pageState);
  }
}

// ============================================== Disposable Base Page ======================================================

class DisposableBasePage<T extends PageProvider<S>, S extends BaseState> extends _BasePage<T, S> {
  const DisposableBasePage({
    super.key,
    required this.provider,
    required super.builder,
    super.listener,
    super.onReady,
    super.initState,
    super.onDispose,
  });

  final AutoDisposeStateNotifierProvider<T, S> provider;

  @override
  ConsumerState<DisposableBasePage<T, S>> createState() => _DisposableBasePageState();
}

class _DisposableBasePageState<T extends PageProvider<S>, S extends BaseState> extends ConsumerState<DisposableBasePage<T, S>> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _createPageModel();
    });
    super.initState();
  }

  void _createPageModel() {
    final pageProvider = ref.read(widget.provider.notifier);
    pageProvider._listener = (state) => widget.listener?.call(context, pageProvider, state);
    pageProvider._context = context;

    if (widget.initState != null) {
      if (pageProvider._onReadyCalled) {
        widget.initState!();
      }
    }

    if (widget.onReady != null) {
      if (!pageProvider._onReadyCalled) {
        widget.onReady!();
        pageProvider._onReadyCalled = true;
      } else {
        widget.onReady!();
      }
    }
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageModel = ref.watch(widget.provider.notifier);
    final pageState = ref.watch(widget.provider);

    return widget.builder(context, pageModel, pageState);
  }
}

// ============================================== Disposable Base Page ======================================================

class BasePageFamily<T extends PageProvider<S>, S extends BaseState, K> extends _BasePage<T, S> {
  const BasePageFamily({
    super.key,
    required this.provider,
    required this.argument,
    required super.builder,
    super.listener,
    super.onReady,
    super.initState,
    super.onDispose,
  });

  final StateNotifierProviderFamily<T, S, K> provider;
  final K argument;

  @override
  ConsumerState<BasePageFamily<T, S, K>> createState() => _BasePageFamily();
}

class _BasePageFamily<T extends PageProvider<S>, S extends BaseState, K> extends ConsumerState<BasePageFamily<T, S, K>> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _createPageModel();
    });
    super.initState();
  }

  void _createPageModel() {
    final pageProvider = ref.read(widget.provider(widget.argument).notifier);
    pageProvider._listener = (state) => widget.listener?.call(context, pageProvider, state);
    pageProvider._context = context;

    if (widget.initState != null) {
      if (pageProvider._onReadyCalled) {
        widget.initState!();
      }
    }

    if (widget.onReady != null) {
      if (!pageProvider._onReadyCalled) {
        widget.onReady!();
        pageProvider._onReadyCalled = true;
      } else {
        widget.onReady!();
      }
    }
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = ref.read(widget.provider(widget.argument).notifier);
    final pageState = ref.watch(widget.provider(widget.argument));

    return widget.builder(context, pageProvider, pageState);
  }
}

import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  final bool isLoading;

  const BaseState(this.isLoading);

  BaseState setLoading(bool loading);
}

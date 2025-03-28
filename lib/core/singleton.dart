import 'package:symbolic/core/numbers.dart' as n;

// ignore_for_file: non_constant_identifier_names
class _SingletonRegistry {
  _SingletonRegistry._();

  final n.Zero Zero = n.Zero.instance;
  final n.One One = n.One.instance;
  final n.NegativeOne NegativeOne = n.NegativeOne.instance;
  final n.Half Half = n.Half.instance;
  final n.Infinity Infinity = n.Infinity.instance;
  final n.NegativeInfinity NegativeInfinity = n.NegativeInfinity.instance;
  final n.ComplexInfinity ComplexInfinity = n.ComplexInfinity.instance;
  final n.NaN NaN = n.NaN.instance;

  static final _SingletonRegistry instance = _SingletonRegistry._();
}

final S = _SingletonRegistry.instance;

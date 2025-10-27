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
  final n.Exp1 Exp1 = n.Exp1.instance;
  final n.Pi Pi = n.Pi.instance;
  final n.GoldenRatio GoldenRatio = n.GoldenRatio.instance;
  final n.ImaginaryUnit I = n.ImaginaryUnit.instance;
  final n.ImaginaryUnit ImaginaryUnit = n.ImaginaryUnit.instance;

  static final _SingletonRegistry instance = _SingletonRegistry._();
}

final S = _SingletonRegistry.instance;

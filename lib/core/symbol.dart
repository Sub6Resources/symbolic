import 'dart:math';

import 'package:symbolic/core/assumptions.dart';
import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/expr.dart';

Map<(String, Assumptions), Symbol> _symbolDictionary = {};

/// TODO add documentation
class Symbol extends AtomicExpr {
  final String name;

  late final Assumptions originalAssumptions;
  late final Assumptions assumptions0;
  late final StdFactKB assumptionsKB;

  Symbol._(this.name, Assumptions assumptions) {
    originalAssumptions = assumptions.copy();
    if (assumptions.commutative == null) {
      assumptions = assumptions.copyWith(commutative: true);
    }

    assumptionsKB = StdFactKB(assumptions);
    assumptions0 = assumptionsKB.toAssumptions();

    addPrecomputedAssumptions(assumptions0);
  }

  factory Symbol(String name, {Assumptions assumptions = const Assumptions()}) {
    if (!_symbolDictionary.containsKey((name, assumptions))) {
      _symbolDictionary[(name, assumptions)] = Symbol._(name, assumptions);
    }

    return _symbolDictionary[(name, assumptions)]!;
  }

  bool get iscomparable => false;

  @override
  bool get isSymbol => true;

  @override
  bool get issymbol => true;

  @override
  Set<Basic> freeSymbols() {
    return {this};
  }

  @override
  Dummy asDummy() {
    if(assumeCommutative != false) {
      return Dummy(name: this.name);
    } else {
      return Dummy(name: this.name, assumptions: Assumptions(commutative: assumeCommutative));
    }
  }

  @override
  Expr func(List<Basic<dynamic>> args) {
    return this;
  }
}

/// TODO add documentation
class Dummy extends Symbol {
  static int _count = 0;
  static final int _baseDummyIndex =
      Random().nextInt(8 * pow(10, 6) as int) + pow(10, 6) as int; // 10^6 to 9*10^6

  late final int dummyIndex;

  Dummy({
    String? name,
    int? dummyIndex,
    Assumptions assumptions = const Assumptions(),
  })  : assert(dummyIndex == null || name != null,
            "If you specify a dummyIndex, you must also provide a name"),
        dummyIndex = dummyIndex ?? Dummy._baseDummyIndex + Dummy._count,
        super._(name ?? "Dummy_${Dummy._count}", assumptions) {
    if (dummyIndex == null) {
      Dummy._count += 1;
    }
  }
}

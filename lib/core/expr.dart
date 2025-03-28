import 'package:symbolic/core/add.dart';
import 'package:symbolic/core/atom.dart';
import 'package:symbolic/core/mul.dart';
import 'package:symbolic/core/power.dart';
import 'package:symbolic/core/singleton.dart';

import 'basic.dart';

class Expr extends Basic {
  Expr(super.args);

  Expr operator -() {
    // TODO final c = isCommutative;
    // TODO return Mul.fromArgs([S.NegativeOne, this], c);

    return Mul([S.NegativeOne, this]);
  }

  Expr operator +(Object? other) {
    if (other is! Expr) {
      throw UnimplementedError(
          "Adding two non-expressions together is not currently supported");
    }
    return Add([this, other]);
  }

  Expr operator -(Object? other) {
    throw UnimplementedError("- not implemented on Expr");
  }

  Expr operator *(Object? other) {
    if (other is! Expr) {
      throw UnimplementedError(
          "Adding two non-expressions together is not currently supported");
    }
    return Mul([this, other]);
  }

  Expr operator ^(Object? other) {
    if (other is! Expr) {
      throw UnimplementedError(
          "Taking the power with a non-Expr exponent is not currently supported");
    }
    return Pow(this, other);
  }

  Expr operator /(Object? other) {
    throw UnimplementedError("/ not implemented on Expr");
  }

  Expr operator %(Object? other) {
    throw UnimplementedError("% not implemented on Expr");
  }

  Expr operator ~/(Object? other) {
    throw UnimplementedError("~/ not implemented on Expr");
  }

  /// Return true if this has -1 as a leading factor or has
  /// more literal negative signs than positive signs in a sum,
  /// otherwise false.
  bool couldExtractMinusSign() {
    return false;
  }

  List<Expr> asOrderedTerms(dynamic order, {bool data = false}) {
    throw UnimplementedError("asOrderedTerms not implemented on Expr");
  }
}

class AtomicExpr extends Expr implements Atom {
  AtomicExpr() : super([]);
}

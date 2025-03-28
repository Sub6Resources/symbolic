import 'package:rational/rational.dart' as rational;
import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/intfunc.dart' show igcd;

class Number extends AtomicExpr {}

class Float extends Number {
  Float(dynamic num, {int? dps, int? precision}) {
    throw UnimplementedError("Float not yet implemented");
  }
}

typedef RealNumber = Float;

/// Represents rational numbers (p/q) of any size.
class Rational extends Number {
  BigInt p;
  BigInt q;

  Rational._(this.p, this.q);

  factory Rational(dynamic p, {dynamic q, BigInt? gcd}) {
    if (q == null) {
      if (p is Rational) {
        return p;
      }

      if (p is int || p is BigInt) {
        // pass
      } else {
        if (p is double) {
          final intRatio = _doubleAsIntegerRatio(p);
          return Rational(intRatio.$1, q: intRatio.$2);
        } else if (p is Float) {
          final intRatio = _floatAsIntegerRatio(p);
          return Rational(intRatio.$1, q: intRatio.$2);
        }

        if (p is String) {
          if (p.count("/") > 1) {
            throw ArgumentError("Invalid input: $p");
          }
          p = p.replaceAll(" ", "");
          final pq = p.split("/");
          if (pq.length == 2) {
            p = pq[0];
            q = pq[1];
            final fp = rational.Rational.parse(p);
            final fq = rational.Rational.parse(q);
            p = fp / fq;
          }

          try {
            p = rational.Rational.parse(p);
            return Rational((p as rational.Rational).numerator,
                q: p.denominator, gcd: BigInt.one);
          } on FormatException {
            // Error will throw below
          }
        }

        if (p is! Rational) {
          throw ArgumentError("Invalid input: $p");
        }
      }

      q = 1;
      gcd = BigInt.one;
    }
    BigInt Q = BigInt.one;

    if (p is! int && p is! BigInt) {
      p = Rational(p);
      Q *= p.q;
      p = p.p;
    } else {
      p = p is int ? BigInt.from(p) : p;
    }
    BigInt pBigInt = p;

    if (q is! int && q is! BigInt) {
      q = Rational(q);
      pBigInt *= (q as Rational).q;
      Q *= q.p;
    } else {
      Q *= q;
    }
    BigInt qBigInt = Q;

    // pBigInt and qBigInt are now BigInts
    if (qBigInt == BigInt.zero) {
      if (pBigInt == BigInt.zero) {
        // TODO check errdict
        throw ArgumentError("Indeterminate 0/0");
      }
      // TODO figure this return out return ComplexInfinity.instance;
    }

    if (qBigInt < BigInt.zero) {
      qBigInt = -qBigInt;
      pBigInt = -pBigInt;
    }
    gcd ??= igcd([pBigInt.abs(), qBigInt]);
    if (gcd > BigInt.one) {
      pBigInt ~/= gcd;
      qBigInt ~/= gcd;
    }
    if (qBigInt == BigInt.one) {
      return Integer(pBigInt);
    }
    if (pBigInt == BigInt.one && qBigInt == BigInt.two) {
      return Half.instance;
    }
    return Rational._(pBigInt, qBigInt);
  }
}

/// Represents integer numbers of any size.
class Integer extends Rational {
  Integer._(BigInt i) : super._(i, BigInt.one);

  factory Integer(dynamic i) {
    if (i is String) {
      i = i.replaceAll(" ", "");
    }

    final iVal = BigInt.tryParse(i.toString());
    if (iVal == null) {
      throw ArgumentError(
          "Argument of Integer should be of numeric type, got $i");
    }

    if (iVal == BigInt.one) {
      return One.instance;
    }
    if (iVal == -BigInt.one) {
      return NegativeOne.instance;
    }
    if (iVal == BigInt.zero) {
      return Zero.instance;
    }

    return Integer._(iVal);
  }
}

class RationalConstant extends Rational {
  RationalConstant._(super.p, super.q) : super._();
}

class IntegerConstant extends Integer {
  IntegerConstant._(super.i) : super._();
}

/// The number zero.
///
/// Zero is a singleton, and can be accessed by `S.Zero`
class Zero extends IntegerConstant {
  Zero._() : super._(BigInt.zero);

  static final Zero instance = Zero._();
}

/// The number one.
///
/// One is a singleton, and can be accessed by `S.One`
class One extends IntegerConstant {
  One._() : super._(BigInt.one);

  static final One instance = One._();
}

/// The number negative one.
///
/// NegativeOne is a singleton, and can be accessed by `S.NegativeOne`
class NegativeOne extends IntegerConstant {
  NegativeOne._() : super._(-BigInt.one);

  static final NegativeOne instance = NegativeOne._();
}

/// The rational number 1/2.
///
/// Half is a singleton, and can be accessed by `S.Half`
class Half extends RationalConstant {
  Half._() : super._(BigInt.one, BigInt.two);

  static final Half instance = Half._();
}

/// Positive infinite quantity.
///
/// Infinity is a singleton, and can be accessed by
/// `S.Infinity`
class Infinity extends Number {
  Infinity._();

  static final Infinity instance = Infinity._();
}

final oo = Infinity.instance;

/// Negative infinite quantity.
///
/// NegativeInfinity is a singleton, and can be accessed
/// by `S.NegativeInfinity`
class NegativeInfinity extends Number {
  NegativeInfinity._();

  static final NegativeInfinity instance = NegativeInfinity._();
}

/// Not a Number.
class NaN extends Number {
  NaN._();

  static final NaN instance = NaN._();
}

final nan = NaN.instance;

/// Complex infinity.
class ComplexInfinity extends AtomicExpr {
  ComplexInfinity._();

  static final ComplexInfinity instance = ComplexInfinity._();
}

final zoo = ComplexInfinity.instance;

class NumberSymbol extends AtomicExpr {
  // TODO
}

/// The `e` constant.
class Exp1 extends NumberSymbol {
  Exp1._();

  static final Exp1 instance = Exp1._();
}

final E = Exp1.instance;

/// The `\pi` constant.
class Pi extends NumberSymbol {
  Pi._();

  static final Pi instance = Pi._();
}

final Pi pi = Pi.instance;

/// The golden ratio, `\phi`.
class GoldenRatio extends NumberSymbol {
  GoldenRatio._();

  static final GoldenRatio instance = GoldenRatio._();
}

/// The imaginary unit, `i = \sqrt{-1}`
class ImaginaryUnit extends AtomicExpr {
  ImaginaryUnit._();

  static final ImaginaryUnit instance = ImaginaryUnit._();
}

final I = ImaginaryUnit.instance;

extension on String {
  int count(String substring) {
    int count = 0;
    int index = 0;
    while ((index = indexOf(substring, index)) != -1) {
      count++;
      index += substring.length;
    }
    return count;
  }
}

(BigInt, BigInt) _doubleAsIntegerRatio(double p) {
  throw UnimplementedError("_doubleAsIntegerRatio not implemented");
}

(BigInt, BigInt) _floatAsIntegerRatio(Float p) {
  throw UnimplementedError("_floatAsIntegerRatio not implemented");
}

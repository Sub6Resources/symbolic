import 'package:rational/rational.dart' as rational;
import 'package:symbolic/core/add.dart';
import 'package:symbolic/core/basic.dart' show Basic;
import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/intfunc.dart' show igcd;
import 'package:symbolic/core/parameters.dart';

class Number extends AtomicExpr {

  Number() {
    addAssumptions(
      commutative: true,
    );
  }

  @override
  bool get isnumber => true;

  @override
  bool get isNumber => true;

  @override
  Expr operator-() {
    throw UnimplementedError();
  }

  @override
  Expr operator+(Object? other) {
    if(other is Number && GlobalParameters.evaluate) {
      if(other is NaN) {
        return NaN.instance;
      } else if(other is Infinity) {
        return Infinity.instance;
      } else if(other is NegativeInfinity) {
        return NegativeInfinity.instance;
      }
    }
    return super + other;
  }

  @override
  Expr operator-(Object? other) {
    if(other is Number && GlobalParameters.evaluate) {
      if(other is NaN) {
        return NaN.instance;
      } else if(other is Infinity) {
        return NegativeInfinity.instance;
      } else if(other is NegativeInfinity) {
        return Infinity.instance;
      }
    }
    return super - other;
  }

  @override
  Expr operator*(Object? other) {
    if(other is Number && GlobalParameters.evaluate) {
      if(other is NaN) {
        return NaN.instance;
      } else if(other is Infinity) {
        if(assumeZero == true) {
          return NaN.instance;
        } else if(assumePositive == true) {
          return Infinity.instance;
        } else {
          // FIXME this might be a bug. What if we can't assume zero positive but it is positive...
          return NegativeInfinity.instance;
        }
      } else if(other is NegativeInfinity) {
        if(assumeZero == true) {
          return NaN.instance;
        } else if(assumePositive == true) {
          return NegativeInfinity.instance;
        } else {
          return Infinity.instance;
        }
      }
    }
    return super * other;
  }

  @override
  Expr operator/(Object? other) {
    if(other is Number && GlobalParameters.evaluate) {
      if(other is NaN) {
        return NaN.instance;
      } else if(other is Infinity || other is NegativeInfinity) {
        return Zero.instance;
      }
    }
    return super / other;
  }

  @override
  bool operator==(Object other) {
    throw UnimplementedError("$runtimeType needs == operator overload");
  }

  @override
  Basic operator<(Object? other) {
    throw UnimplementedError("$runtimeType needs < operator overload");
  }

  @override
  Basic operator<=(Object? other) {
    throw UnimplementedError("$runtimeType needs <= operator overload");
  }

  @override
  Basic operator>(Object? other) {
    throw UnimplementedError("$runtimeType needs > operator overloaded");
  }

  @override
  Basic operator>=(Object? other) {
    throw UnimplementedError("$runtimeType needs >= operator overloaded");
  }

  @override
  //ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  @override
  Expr func(List<Basic<dynamic>> args) {
    return this; // All numbers are atomic with no arguments
  }
}

class Float extends Number {
  final int? precision;

  Float(dynamic num, {int? dps, this.precision}) {
    throw UnimplementedError("Float not yet implemented");
  }

  @override
  bool get isFloat => true;

  @override
  bool get isnumber => true;
}

typedef RealNumber = Float;

/// Represents rational numbers (p/q) of any size.
class Rational extends Number {
  BigInt p;
  BigInt q;

  Rational._(this.p, this.q) {
    addAssumptions(
      real: true,
      integer: false,
      rational: true,
      positive: _assumePositive,
      zero: _assumeZero,
    );
  }

  @override
  bool get isnumber => true;

  @override
  bool get isRational => true;

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
    } else if (q is int) {
      q = BigInt.from(q);
      Q *= q;
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

  /// Returns the closest rational to this with denominator at most
  /// maxDenominator.
  ///
  /// Examples
  /// ========
  ///
  /// ```dart
  /// print(Rational('3.141592653589793').limitDenominator(10)); "22/7"
  /// print(Rational('3.141592653589793').limitDenominator(100)); "311/99"
  /// ```
  Rational limitDenominator([int maxDenominator=1000000]) {
    throw UnimplementedError("limitDenominator is not implemented on Rational");
  }

  @override
  Expr operator-() {
    return Rational._(-p, q);
  }

  @override
  Expr operator+(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is Integer) {
        return Rational._(p + q * other.p, q);
      } else if(other is Rational) {
        return Rational(p*other.q + q*other.p, q: q*other.q);
      } if(other is Float) {
        return other + this;
      } else {
        return super + other;
      }
    }
    return super + other;
  }

  @override
  Expr operator-(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is Integer) {
        return Rational._(p - q*other.p, q);
      } else if(other is Rational) {
        return Rational(p*other.q - q*other.p, q: q*other.q);
      } else if(other is Float) {
        return -other + this;
      } else {
        return super - other;
      }
    }
    return super - other;
  }

  @override
  Expr operator*(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is Integer) {
        return Rational(p*other.p, q: q, gcd: igcd([other.p, q]));
      } else if(other is Rational) {
        return Rational(p*other.p, q: q*other.q, gcd: igcd([p, other.q])*igcd([q, other.p]));
      } else if(other is Float) {
        return other*this;
      } else {
        return super * other;
      }
    }
    return super * other;
  }

  @override
  Expr operator/(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is Integer) {
        if(p != BigInt.zero && other.p == BigInt.zero) {
          return ComplexInfinity.instance;
        } else {
          return Rational(p, q: q*other.p, gcd: igcd([p, other.p]));
        }
      } else if(other is Rational) {
        return Rational(p*other.q, q: q*other.p, gcd: igcd([p, other.p])*igcd([q*other.q]));
      } else if(other is Float) {
        return this*(One.instance/other);
      } else {
        return super/other;
      }
    }
    return super/other;
  }

  @override
  Expr operator%(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is Rational) {
        final n = (p*other.q) ~/ (other.p*q);
        return Rational(p*other.q - n*other.p*q, q: q*other.q);
      } else if(other is Float) {
        // calculate mod with Rationals, *then* round the answer
        return Float(this % Rational(other), precision: other.precision);
      }
      return super % other;
    }
    return super % other;
  }

  // TODO evalPower

  @override
  Expr abs() {
    return Rational._(p.abs(), q);
  }

  @override
  BigInt toInt() {
    if(p < BigInt.zero) {
      return -(-p ~/ q);
    }
    return p ~/ q;
  }

  @override
  bool operator==(Object other) {
    // TODO sympify
    if(other is! Number) {
      return false;
    }
    if(other.isNumberSymbol) {
      if(other.assumeIrrational == true) {
        return false;
      }
      return other == this;
    }
    if(other.isRational && other is Rational) {
      // a Rational is always in reduced form so will never be 2/4
      // so we can just check equivalence of args
      return p == other.p && q == other.q;
    }
    return false;
  }

  @override
  Basic operator>(Object? other) {
    throw UnimplementedError("> not implemented on Rational");
  }

  @override
  Basic operator<(Object? other) {
    throw UnimplementedError("< not implemented on Rational");
  }

  @override
  Basic operator>=(Object? other) {
    throw UnimplementedError(">= not implemented on Rational");
  }

  @override
  Basic operator<=(Object? other) {
    throw UnimplementedError("<= not implemented on Rational");
  }

  @override
  //ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  BigInt get numerator => p;

  BigInt get denominator => q;

  bool? get _assumePositive {
    return p > BigInt.zero;
  }

  bool? get _assumeZero {
    return p == BigInt.zero;
  }

  /// Return the tuple (R, self/R) where R is the positive Rational
  /// extracted from self.
  @override
  (Basic, Basic) asContentPrimitive({bool radical = false, bool clear=true}) {
    if(assumePositive == true) {
      return (this, One.instance);
    }
    return (-this, NegativeOne.instance);
  }
}

/// Represents integer numbers of any size.
class Integer extends Rational {
  Integer._(BigInt i) : super._(i, BigInt.one) {
    addAssumptions(
      integer: true,
      odd: _assumeOdd,
      prime: _assumePrime,
      composite: _assumeComposite,
    );
  }

  @override
  bool get isnumber => true;

  @override
  bool get isInteger => true;

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

  @override
  BigInt toInt() {
    return p;
  }

  @override
  Expr operator -() {
    return Integer._(-p);
  }

  @override
  Expr abs() {
    if(p >= BigInt.zero) {
      return this;
    } else {
      return Integer._(-p);
    }
  }

  @override
  Expr operator +(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is int) {
        return Integer._(p + BigInt.from(other));
      } else if(other is BigInt) {
        return Integer._(p + other);
      } else if(other is Integer) {
        return Integer._(p + other.p);
      } else if(other is Rational) {
        return Rational(p*other.q + other.p, q: other.q, gcd: BigInt.one);
      }
      return super + other;
    } else if(other is Expr) {
      return Add([this, other]);
    }

    throw UnimplementedError("Cannot add Integer and ${other.runtimeType}");
  }

  @override
  Expr operator-(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is int) {
        return Integer._(p - BigInt.from(other));
      } else if(other is BigInt) {
        return Integer._(p - other);
      } else if(other is Integer) {
        return Integer._(p - other.p);
      } else if(other is Rational) {
        return Rational(p*other.q - other.p, q: other.q, gcd: BigInt.one);
      }
      return super - other;
    }
    return super - other;
  }

  @override
  Expr operator*(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is int) {
        return Integer._(p*BigInt.from(other));
      } else if(other is BigInt) {
        return Integer._(p*other);
      } else if(other is Integer) {
        return Integer._(p*other.p);
      } else if(other is Rational) {
        return Rational(p*other.p, q: other.q, gcd: igcd([p, other.q]));
      }
      return super * other;
    }
    return super * other;
  }

  @override
  Expr operator%(Object? other) {
    if(GlobalParameters.evaluate) {
      if(other is int) {
        return Integer._(p % BigInt.from(other));
      } else if(other is BigInt) {
        return Integer._(p % other);
      } else if(other is Integer) {
        return Integer._(p % other.p);
      }
      return super % other;
    }
    return super % other;
  }

  @override
  bool operator==(Object other) {
    if(other is int) {
      return (p == BigInt.from(other));
    } else if(other is BigInt) {
      return (p == other);
    } else if(other is Integer) {
      return (p == other.p);
    }

    return super == other;
  }

  @override
  Basic operator>(Object? other) {
    if(other is! Basic) {
      // TODO symbolify input
      throw UnimplementedError("> not implemented for non-Basic types");
    }
    if(other.isInteger) {
      // TODO symbolify
      // return Bool(p > other.p);
    }

    return super > other;
  }

  @override
  Basic operator<(Object? other) {
    if(other is! Basic) {
      // TODO symbolify input
      throw UnimplementedError("> not implemented for non-Basic types");
    }
    if(other.isInteger) {
      // TODO symbolify
      // return p < other.p;
    }

    return super < other;
  }

  @override
  Basic operator>=(Object? other) {
    if(other is! Basic) {
      // TODO symbolify input
      throw UnimplementedError("> not implemented for non-Basic types");
    }
    if(other.isInteger) {
      // TODO symbolify
      // return Bool(p >= other.p);
    }

    return super >= other;
  }

  @override
  Basic operator<=(Object? other) {
    if(other is! Basic) {
      // TODO symbolify input
      throw UnimplementedError("> not implemented for non-Basic types");
    }
    if(other.isInteger) {
      // TODO symbolify
      // return Bool(p <= other.p);
    }

    return super <= other;
  }

  @override
  int get hashCode => p.hashCode;

  bool? get _assumeOdd => p.isOdd;

  bool? get _assumePrime {
    // TODO implement
    return null;
  }

  bool? get _assumeComposite {
    // TODO implement
    return null;
  }

  @override
  Expr operator ~/(Object? other) {
    // TODO symbolify
    if(other is! Expr && other is! int) {
      throw UnimplementedError("Cannot ~/ using non-Expr");
    } else if(other is int) {
      return Integer._(p ~/ BigInt.from(other));
    } else if(other is BigInt) {
      return Integer._(p ~/ other);
    } else if(other is Integer) {
      return Integer._(p ~/ other.p);
    }

    return super ~/ other;
  }


  Expr operator <<(int shiftAmount) {
    return Integer._(p << shiftAmount);
  }

  Expr operator >>(int shiftAmount) {
    return Integer._(p >> shiftAmount);
  }

  Expr operator &(Object? other) {
    if(other is int) {
      return Integer._(p & BigInt.from(other));
    } else if(other is BigInt) {
      return Integer._(p & other);
    } else if(other is Integer) {
      return Integer._(p & other.p);
    }

    throw UnimplementedError("& not implemented for Integer and ${other.runtimeType}");
  }

  Expr operator ^(Object? other) {
    if(other is int) {
      return Integer._(p ^ BigInt.from(other));
    } else if(other is BigInt) {
      return Integer._(p ^ other);
    } else if(other is Integer) {
      return Integer._(p ^ other.p);
    }

    throw UnimplementedError("^ not implemented for Integer and ${other.runtimeType}");
  }

  Expr operator |(Object? other) {
    if(other is int) {
      return Integer._(p | BigInt.from(other));
    } else if(other is BigInt) {
      return Integer._(p | other);
    } else if(other is Integer) {
      return Integer._(p | other.p);
    }

    throw UnimplementedError("| not implemented for Integer and ${other.runtimeType}");
  }

  Expr operator ~() {
    return Integer._(~p);
  }
}

/// Abstract base class for rationals with specific behaviors
///
/// Derived classes must define p and q and should probably all
/// be singletons.
abstract class RationalConstant extends Rational {
  RationalConstant._(super.p, super.q) : super._();
}

abstract class IntegerConstant extends Integer {
  IntegerConstant._(super.i) : super._();
}

/// The number zero.
///
/// Zero is a singleton, and can be accessed by `S.Zero`
class Zero extends IntegerConstant {
  Zero._() : super._(BigInt.zero) {
    addAssumptions(
      positive: false,
      negative: false,
      zero: true,
    );
  }

  @override
  bool get isnumber => true;

  bool get iscomparable => true;

  static final Zero instance = Zero._();

  @override
  Expr abs() {
    return Zero.instance;
  }

  @override
  Expr operator -() {
    return Zero.instance;
  }

  bool toBool() {
    return false;
  }
}

/// The number one.
///
/// One is a singleton, and can be accessed by `S.One`
class One extends IntegerConstant {
  One._() : super._(BigInt.one) {
    addAssumptions(
      positive: true,
    );
  }

  @override
  bool get isnumber => true;

  static final One instance = One._();

  @override
  Expr abs() {
    return One.instance;
  }

  @override
  Expr operator -() {
    return NegativeOne.instance;
  }
}

/// The number negative one.
///
/// NegativeOne is a singleton, and can be accessed by `S.NegativeOne`
class NegativeOne extends IntegerConstant {
  NegativeOne._() : super._(-BigInt.one);

  @override
  bool get isnumber => true;

  static final NegativeOne instance = NegativeOne._();

  @override
  Expr abs() {
    return One.instance;
  }

  @override
  Expr operator-() {
    return One.instance;
  }
}

/// The rational number 1/2.
///
/// Half is a singleton, and can be accessed by `S.Half`
class Half extends RationalConstant {
  Half._() : super._(BigInt.one, BigInt.two);

  @override
  bool get isnumber => true;

  static final Half instance = Half._();

  @override
  Expr abs() {
    return Half.instance;
  }
}

/// Positive infinite quantity.
///
/// Infinity is a singleton, and can be accessed by
/// `S.Infinity`
class Infinity extends Number {
  Infinity._() {
    addAssumptions(
      commutative: true,
      complex: false,
      extendedReal: true,
      infinite: true,
      extendedPositive: true,
      prime: false,
    );
  }

  @override
  bool get isnumber => true;

  bool get iscomparable => true;

  static final Infinity instance = Infinity._();

  @override
  Expr operator+(Object? other) {
    if (other is Number && GlobalParameters.evaluate) {
      if(other is NegativeInfinity || other is NaN) {
        return NaN.instance;
      }
      return this;
    }
    return super + other;
  }

  @override
  Expr operator-(Object? other) {
    if (other is Number && GlobalParameters.evaluate) {
      if(other is Infinity || other is NaN) {
        return NaN.instance;
      }
      return this;
    }
    return super - other;
  }

  @override
  Expr operator*(Object? other) {
    if (other is Number && GlobalParameters.evaluate) {
      if(other.assumeZero == true || other is NaN) {
        return NaN.instance;
      }
      if(other.assumeExtendedPositive == true) {
        return this;
      }
      return NegativeInfinity.instance;
    }
    return super * other;
  }

  @override
  Expr operator/(Object? other) {
    if (other is Number && GlobalParameters.evaluate) {
      if(other is Infinity || other is NegativeInfinity || other is NaN) {
        return NaN.instance;
      }
      if(other.assumeExtendedNonNegative == true) {
        return this;
      }
      return NegativeInfinity.instance;
    }
    return super / other;
  }

  @override
  Expr abs() {
    return Infinity.instance;
  }

  @override
  Expr operator-() {
    return NegativeInfinity.instance;
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  @override
  bool operator==(Object other) {
    return other is Infinity || other == double.infinity;
  }
}

final oo = Infinity.instance;

/// Negative infinite quantity.
///
/// NegativeInfinity is a singleton, and can be accessed
/// by `S.NegativeInfinity`
class NegativeInfinity extends Number {
  NegativeInfinity._() {
    addAssumptions(
      extendedReal: true,
      complex: false,
      commutative: true,
      infinite: true,
      extendedNegative: true,
      prime: false,
    );
  }

  @override
  bool get isnumber => true;

  bool get iscomparable => true;

  static final NegativeInfinity instance = NegativeInfinity._();

  @override
  Expr operator+(Object? other) {
    if (other is Number && GlobalParameters.evaluate) {
      if(other is Infinity || other is NaN) {
        return NaN.instance;
      }
      return this;
    }
    return super + other;
  }

  @override
  Expr operator-(Object? other) {
    if (other is Number && GlobalParameters.evaluate) {
      if(other is NegativeInfinity || other is NaN) {
        return NaN.instance;
      }
      return this;
    }
    return super - other;
  }

  @override
  Expr operator*(Object? other) {
    if (other is Number && GlobalParameters.evaluate) {
      if(other.assumeZero == true || other is NaN) {
        return NaN.instance;
      }
      if(other.assumeExtendedPositive == true) {
        return this;
      }
      return Infinity.instance;
    }
    return super * other;
  }

  @override
  Expr operator/(Object? other) {
    if (other is Number && GlobalParameters.evaluate) {
      if(other is Infinity || other is NegativeInfinity || other is NaN) {
        return NaN.instance;
      }
      if(other.assumeExtendedNonNegative == true) {
        return this;
      }
      return Infinity.instance;
    }
    return super / other;
  }

  @override
  Expr abs() {
    return Infinity.instance;
  }

  @override
  Expr operator-() {
    return Infinity.instance;
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  @override
  bool operator==(Object other) {
    return other is NegativeInfinity || other == double.negativeInfinity;
  }
}

/// Not a Number.
class NaN extends Number {
  NaN._() {
    addAssumptions(
      commutative: true,
      extendedReal: null,
      real: null,
      rational: null,
      algebraic: null,
      transcendental: null,
      integer: null,
      finite: null,
      zero: null,
      prime: null,
      positive: null,
      negative: null,
    );
  }

  @override
  bool get isnumber => true;

  bool get iscomparable => false;

  static final NaN instance = NaN._();

  @override
  Expr operator-() {
    return this;
  }

  @override
  Expr operator+(Object? other) {
    return this;
  }

  @override
  Expr operator-(Object? other) {
    return this;
  }

  @override
  Expr operator*(Object? other) {
    return this;
  }

  @override
  Expr operator/(Object? other) {
    return this;
  }

  @override
  bool operator==(Object other) {
    return other is NaN;
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}

final nan = NaN.instance;

/// Complex infinity.
class ComplexInfinity extends AtomicExpr {
  ComplexInfinity._() {
    addAssumptions(
      commutative: true,
      infinite: true,
      prime: false,
      complex: false,
      extendedReal: false,
    );
  }

  @override
  bool get isnumber => true;

  static final ComplexInfinity instance = ComplexInfinity._();

  @override
  Expr abs() {
    return Infinity.instance;
  }

  @override
  Expr operator -() {
    return ComplexInfinity.instance;
  }

  @override
  Expr func(List<Basic<dynamic>> args) {
    return ComplexInfinity.instance;
  }
}

final zoo = ComplexInfinity.instance;

class NumberSymbol extends AtomicExpr {
  NumberSymbol() {
    addAssumptions(
      commutative: true,
      finite: true,
    );
  }

  @override
  bool get isnumber => true;

  @override
  bool get isNumberSymbol => true;

  @override
  bool operator ==(Object other) {
    if(other is! Basic) {
      throw UnimplementedError();
    }

    if(identical(this, other)) {
      return true;
    }

    if(other.isNumber && assumeIrrational == true) {
      return false;
    }

    return false; // NumberSymbol != non-(Number|this)
  }

  @override
  //ignore: unnecessary_overrides
  int get hashCode => super.hashCode;


  @override
  Basic operator <=(Object? other) {
    if(identical(this, other)) {
      // TODO return S.true
      throw UnimplementedError("<= not implemented on NumberSymbol");
    }
    return super <= other;
  }

  @override
  Basic operator >=(Object? other) {
    if(identical(this, other)) {
      // TODO return S.true
      throw UnimplementedError(">= not implemented on NumberSymbol");
    }
    return super >= other;
  }

  @override
  BigInt toInt() {
    throw UnimplementedError("subclass of NumberSymbol did not implement toInt");
  }

  @override
  Expr func(List<Basic<dynamic>> args) {
    return this;
  }

}

/// The `e` constant.
class Exp1 extends NumberSymbol {
  Exp1._() {
    addAssumptions(
      real: true,
      positive: true,
      negative: false,
      irrational: true,
      algebraic: false,
      transcendental: true,
    );
  }

  @override
  bool get isnumber => true;

  static final Exp1 instance = Exp1._();

  @override
  Expr abs() {
    return Exp1.instance;
  }

  @override
  BigInt toInt() => BigInt.two;
}

final E = Exp1.instance;

/// The `\pi` constant.
class Pi extends NumberSymbol {
  Pi._() {
    addAssumptions(
      real: true,
      positive: true,
      negative: false,
      irrational: true,
      algebraic: false,
      transcendental: true,
    );
  }

  @override
  bool get isnumber => true;

  static final Pi instance = Pi._();

  @override
  Expr abs() {
    return Pi.instance;
  }

  @override
  BigInt toInt() {
    return BigInt.from(3);
  }
}

final Pi pi = Pi.instance;

/// The golden ratio, `\phi`.
class GoldenRatio extends NumberSymbol {
  GoldenRatio._() {
    addAssumptions(
      real: true,
      positive: true,
      negative: false,
      irrational: true,
      algebraic: true,
      transcendental: false,
    );
  }

  @override
  bool get isnumber => true;

  static final GoldenRatio instance = GoldenRatio._();

  @override
  BigInt toInt() => BigInt.one;
}

/// The imaginary unit, `i = \sqrt{-1}`
class ImaginaryUnit extends AtomicExpr {
  ImaginaryUnit._() {
    addAssumptions(
      commutative: true,
      imaginary: true,
      finite: true,
      algebraic: true,
      transcendental: false,
    );
  }

  @override
  bool get isnumber => true;

  static final ImaginaryUnit instance = ImaginaryUnit._();

  @override
  Expr abs() {
    return One.instance;
  }

  @override
  Expr func(List<Basic<dynamic>> args) {
    return ImaginaryUnit.instance;
  }
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
  if (p.isNaN) {
    throw ArgumentError("Cannot convert NaN to a rational");
  }
  if (p.isInfinite) {
    throw ArgumentError("Cannot convert infinity to a rational");
  }
  final str = p.toString();
  if (!str.contains('e') && !str.contains('E')) {
    if (str.contains('.')) {
      final parts = str.split('.');
      final intPart = parts[0];
      final fracPart = parts[1];
      final denominator = BigInt.from(10).pow(fracPart.length);
      final numerator = BigInt.parse(intPart) * denominator + BigInt.parse(fracPart
          .replaceAll('-', ''));
      return (numerator, denominator);
    } else {
      return (BigInt.parse(str), BigInt.one);
    }
  }

  // Handle scientific notation
  final sciParts = str.split(RegExp(r'[eE]'));
  final basePart = sciParts[0];
  final exponentPart = int.parse(sciParts[1]);
  BigInt numerator;
  BigInt denominator;
  if (basePart.contains('.')) {
    final parts = basePart.split('.');
    final intPart = parts[0];
    final fracPart = parts[1];
    denominator = BigInt.from(10).pow(fracPart.length);
    numerator = BigInt.parse(intPart) * denominator + BigInt.parse(fracPart
        .replaceAll('-', ''));
  } else {
    numerator = BigInt.parse(basePart);
    denominator = BigInt.one;
  }
  if (exponentPart > 0) {
    numerator *= BigInt.from(10).pow(exponentPart);
  } else if (exponentPart < 0) {
    denominator *= BigInt.from(10).pow(-exponentPart);
  }
  return (numerator, denominator);
}

(BigInt, BigInt) _floatAsIntegerRatio(Float p) {
  throw UnimplementedError("_floatAsIntegerRatio not implemented");
}

final illegalNumbers = {NaN.instance, Infinity.instance, NegativeInfinity.instance, ComplexInfinity.instance};

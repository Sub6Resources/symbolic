import 'package:symbolic/core/add.dart';
import 'package:symbolic/core/mul.dart';
import 'package:symbolic/core/power.dart';
import 'package:symbolic/core/singleton.dart';
import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/numbers.dart';
import 'package:symbolic/simplify/simplify.dart';

import 'exprtools.dart';

abstract class Expr extends Basic<Expr> {
  Expr(super.args) {
    addAssumptions(
      extendedPositive: _assumeExtendedPositive,
      extendedNegative: _assumeExtendedNegative,
    );
  }

  final bool isscalar = true; // self-derivative is 1

  Expr operator -() {
    final c = assumeCommutative;
    // TODO return Mul.fromArgs([S.NegativeOne, this], c);

    return Mul([S.NegativeOne, this]);
  }

  Expr operator +(Object? other) {
    if (other is! Expr) {
      throw UnimplementedError(
          "Adding a non-expression is not currently supported");
    }
    return Add([this, other]);
  }

  Expr operator -(Object? other) {
    if(other is! Expr) {
      throw UnimplementedError(
          "Subtracting a non-expressions is not currently supported");
    }
    return Add([this, -other]);
  }

  Expr operator *(Object? other) {
    if (other is! Expr) {
      throw UnimplementedError(
          "Multiplying two non-expressions together is not currently supported");
    }
    return Mul([this, other]);
  }

  Expr abs() {
     throw UnimplementedError("abs is not implemented on Expr");
     // return Abs(this);
  }

  Expr operator /(Object? other) {
    if(other is! Expr) {
      throw UnimplementedError("Dividing two non-expressions is not currently supported");
    }
    final denom = Pow(other, NegativeOne.instance);
    if(this is One) {
      return denom;
    } else {
      return Mul([this, denom]);
    }
  }

  Expr operator %(Object? other) {
    throw UnimplementedError("% not implemented on Expr");
  }

  Expr operator ~/(Object? other) {
    throw UnimplementedError("~/ not implemented on Expr");
  }

  BigInt toInt() {
    throw UnimplementedError("toInt not implemented on Expr");
  }

  double toDouble() {
    throw UnimplementedError("toDouble not implemented on Expr");
  }

  Basic operator >=(Object? other) {
    throw UnimplementedError(">= not implemented on Expr");
  }

  Basic operator <=(Object? other) {
    throw UnimplementedError("<= not implemented on Expr");
  }

  Basic operator >(Object? other) {
    throw UnimplementedError("> not implemented on Expr");
  }

  Basic operator <(Object? other) {
    throw UnimplementedError("< not implemented on Expr");
  }

  Expr truncate() {
    if(!isnumber) {
      throw UnimplementedError("cannot truncate symbols and expressions");
    } else {
      return Integer(this);
    }
  }

  /// true if this expression has no free symbols and no
  /// undefined functions (AppliedUndef, to be precise). It will be
  /// faster than `.freeSymbols.isEmpty`, however, since
  /// `isnumber` will fail as soon as it hits a free symbol
  /// or undefined function.
  @override
  bool get isnumber {
    return args.every((obj) => obj.isnumber);
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

  /// Return a tuple (c, args)
  ///
  /// c should be a rational multiplied by any factors of the Mul that are
  /// independent of deps.
  ///
  /// args should be  tuple of all other factors of m; args is empty
  /// if this is a Number or if this is independent of deps (when given).
  ///
  /// This should be used when you do not know if this object is a Mul or
  /// not but you want to treat this as a Mul, or if you want to process the
  /// individual arguments of the tail of this as a Mul.
  ///
  /// - if you know this is a Mul and want only the head, use `.args[0]`
  /// - if you do not want too process the arguments of the tail but need the
  ///   tail then use `.asTwoTerms()` which gives the head and tail;
  /// - if you want to split this into an independent and dependent parts
  ///   use `.asIndependent(deps)`.
  (Expr, List<Expr>) asCoeffMulDep(List<Expr> deps) {
    if(deps.isNotEmpty) {
      if(!has(deps)) {
        return (this, []);
      }
    }
    return (S.One, [this,]);
  }

  /// Efficiently extract the coefficient of a product.
  (Number, Expr) asCoeffMul({bool rational = false}) {
    return (S.One, this);
  }

  /// Efficiently extract the coefficient of a summation.
  (Number, Expr) asCoeffAdd({bool rational = false}) {
    return (S.Zero, this);
  }

  /// This method should recursively remove a Rational from all arguments
  /// and return that (content) and the new this (primitive). The content
  /// should always be positive and ``Mul(foo.as_content_primitive()) == foo``.
  /// The primitive need not be in canonical form and should try to preserve
  /// the underlying structure if possible (i.e. expand_mul should not be
  /// applied to self).
  @override
  (Basic<dynamic>, Basic<dynamic>) asContentPrimitive({bool radical = false, bool clear=true}) {
    return (One.instance, this);
  }

  bool? _assumeExtendedPositiveNegative(bool positive) {
    return null;
    // TODO full implementation
  }

  bool? get _assumeExtendedPositive => _assumeExtendedPositiveNegative(true);
  bool? get _assumeExtendedNegative => _assumeExtendedPositiveNegative(false);

  // @override
  // Expr func(List<Basic<dynamic>> args) {
  //   return Expr(args);
  // }

  bool? equals(Basic other) {
    if(other is! Expr) {
      return false;
    }

    if(this == other) {
      return true;
    }

    // they aren't the same so see if we can maake the difference 0;
    // don't worry about doing simplification steps one at a time
    // because if the expression ever goes to 0 then the subsequent
    // simplification steps that are done will be very fast.
    // TODO final diff = factorTerms(simplify(this-other), radical: true);

    // TODO if(!diff.has([Add, Mod])) {
    //  return false;
    // }

    // TODO there's a lot more here

    return null;
  }
}

abstract class AtomicExpr extends Expr implements Atom, EvalSimplify {
  AtomicExpr() : super([]);

  @override
  bool get isnumber => false;

  @override
  bool get isAtom => true;

  @override
  T evalSimplify<T>({double ratio = 1.7, bool inverse=false,}) {
    return this as T;
  }
}

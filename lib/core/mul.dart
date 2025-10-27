import 'package:symbolic/core/add.dart';
import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/logic.dart';
import 'package:symbolic/core/numbers.dart';
import 'package:symbolic/core/singleton.dart';

class Mul extends Expr {
  final bool evaluate;

  Mul(List<Expr> super.args, {this.evaluate = true}) {
    addAssumptions(
      commutative: _assumeCommutative,
      complex: _assumeComplex,
      zero: _assumeZero,
      infinite: _assumeInfinite,
      rational: _assumeRational,
      algebraic: _assumeAlgebraic,
      integer: _assumeInteger,
      imaginary: _assumeImaginary,
      hermitian: _assumeHermitian,
      antiHermitian: _assumeAntiHermitian,
      irrational: _assumeIrrational,
      extendedPositive: _assumeExtendedPositive,
      extendedNegative: _assumeExtendedNegative,
      odd: _assumeOdd,
      even: _assumeEven,
      composite: _assumeComposite,
    );
  }

  @override
  bool get isMul => true;

  @override
  List<Expr> get args => List<Expr>.from(super.args);

  @override
  bool couldExtractMinusSign() {
    // TODO
    return false;
  }

  bool? get _assumeCommutative => fuzzyGroup([for(final a in args) a.assumeCommutative]);

  bool? get _assumeComplex {
    final comp = fuzzyGroup([for(final a in args) a.assumeComplex]);
    if(comp == false) {
      if(args.any((a) => a.assumeInfinite == true)) {
        if(args.any((a) => a.assumeZero != false)) {
          return null;
        }
        return false;
      }
    }
    return comp;
  }

  /// Helper use by _assumeZero and _assumeInfinite.
  ///
  /// Three-valued logic is tricky so let us reason this carefully. It
  /// would be nice to say that we just check assumeZero/assumeInfinite in all
  /// args but we need to be careful about the case that one arg is zero
  /// and another is infinite like Mul(0, oo) or more importantly a case
  /// where it is not known if the arguments are zero or infinite like
  /// Mul(y, 1/x). If either y or x could be zero then there is a
  /// *possibility* that we have Mul(0, oo) which should give null for both
  /// assumeZero and assumeInfinite.
  ///
  /// We keep track of whether we have seen a zero or infinity but we also
  /// need to keep track of whether we have *possibly* seen one which
  /// would be indicated by null.
  /// 
  /// For each argument there is the possibility that assumeZero might give
  /// true, false or null and likewise that assumeInfinite might give true,
  /// false or null, giving 9 combinations. The true cases for assumeZero and
  /// assumeInfinite are mutually exclusive though so there are 3 main cases:
  /// 
  ///  - assumeZero = true
  ///  - assumeInfinite = true
  ///  - assumeZero and assumeInfinite are both either false or null
  /// 
  /// At the end seenZero and seenInfinite can be any of 9 combinations
  /// of true/false/null. Unless one is false though we cannot return
  /// anything except null:
  /// 
  ///  - assumeZero=true needs seenZero=true and seenInfinite=false
  ///  - assumeZero=false needs seenZero=false
  ///  - assumeInfinite=true needs seenInfinite=true and seenZero=false
  ///  - assumeInfinite=false needs seenInfinite=False
  ///  - anything else gives both assumeZero=null and assumeInfinite=null
  ///
  ///  The loop only sets the flags to true or null and never back to false.
  ///  Hence as soon as neither flag is false we exit early returning null.
  ///  In particular as soon as we encounter a single arg that has
  ///  assumeZero=assumeInfinite=null we exit. This is a common case since it is
  ///  the default assumptions for a Symbol and also the case for most
  ///  expressions containing such a symbol. The early exit gives a big
  ///  speedup for something like Mul([...symbols('x:1000')]).assumeZero.
  (bool?, bool?) _assumeZeroInfiniteHelper() {
    bool? seenZero = false;
    bool? seenInfinite = false;

    for(final a in args) {
      if(a.assumeZero == true) {
        if(seenInfinite != false) {
          return (null, null);
        }
        seenZero = true;
      } else if(a.assumeInfinite == true) {
        if(seenZero != false) {
          return (null, null);
        }
        seenInfinite = true;
      } else {
        if(seenZero == false && a.assumeZero == null) {
          if((seenInfinite != false)) {
            return (null, null);
          }
          seenZero = null;
        }
        if(seenInfinite == false && a.assumeInfinite == null) {
          if((seenZero != false)) {
            return (null, null);
          }
          seenInfinite = null;
        }
      }
    }

    return (seenZero, seenInfinite);
  }

  bool? get _assumeZero {
    // True iff any arg is zero and no arg is infinite but need to handle
    // three valued logic carefully.
    final (seenZero, seenInfinite) = _assumeZeroInfiniteHelper();

    if(seenZero == false) {
      return false;
    } else if(seenZero == true && seenInfinite == false) {
      return true;
    } else {
      return null;
    }
  }

  bool? get _assumeInfinite {
    // True iff any arg is infinite and no arg is zero but need to handle
    // three valued logic carefully.
    final (seenZero, seenInfinite) = _assumeZeroInfiniteHelper();

    if(seenInfinite == false) {
      return false;
    } else if(seenInfinite == true && seenZero == false) {
      return true;
    } else {
      return null;
    }
  }

  // We do not need to implement _assumeFinite because the assumptions
  // system can infer it from finite = not infinite.

  bool? get _assumeRational {
    final r = fuzzyGroup([for(final a in args) a.assumeRational], quickExit: true);
    if(r == true) {
      return r;
    } else if(r == false) {
      // All args except one are rational
      if(args.every((a) => a.assumeZero == false)) {
        return false;
      }
    }
    return null;
  }

  bool? get _assumeAlgebraic {
    final r = fuzzyGroup([for(final a in args) a.assumeAlgebraic], quickExit: true);
    if(r == true) {
      return r;
    } else if(r == false) {
      // All args except one are algebraic
      if(args.every((a) => a.assumeZero == false)) {
        return false;
      }
    }
    return null;
  }

  bool? get _assumeInteger {
    final isRational = _assumeRational;
    if(isRational == false) {
      return false;
    }

    // TODO finish implementing
    return null;
  }

  // TODO add
  // bool? get _assumePolar {
  //   throw UnimplementedError("polar assumption not implemented in Mul");
  // }

  bool? _assumeRealImagHelper(bool real) {
    bool? zero = false;
    Expr? tNotReIm;

    for(final t in args) {
      if((t.assumeComplex == true || t.assumeInfinite == true) == false && t.assumeExtendedReal == false) {
        return false;
      } else if(t.assumeImaginary == true) {
        // e.g. I
        real = !real;
      } else if(t.assumeExtendedReal == true) {
        // e.g. 2
        if(zero != true) {
          final z = t.assumeZero;
          if(z != true && zero == false) {
            zero = z;
          } else if(z == true) {
            if(args.every((a) => a.assumeFinite == true)) {
              return true;
            }
            return null;
          }
        }
      } else if(t.assumeExtendedReal == false) {
        // symbolic r literal like `2 + I` or symbolic imaginary
        if(tNotReIm != null) {
          return null; // complex terms might cancel
        }
        tNotReIm = t;
      } else if(t.assumeImaginary == false) {
        // symbolic like `2` or `2 + I`
        if(tNotReIm != null) {
          return null; // complex terms might cancel
        }
        tNotReIm = t;
      } else {
        return null;
      }
    }

    if(tNotReIm != null) {
      if(tNotReIm.assumeExtendedReal == false) {
        if(real) {
          // like 3
          return zero; // 3 * (something like 2 or 2 + I) is not real
        }
      }
      if(tNotReIm.assumeImaginary == false) {
        if(!real) {
          // like I
          return zero; // I * (something like 2 or 2 + I) is not real
        }
      }
    } else if(zero == false) {
      return real;  // can't be trumped by 0
    } else if(real) {
      return real;  // doesn't matter what zero is
    }

    return null;
  }

  bool? get _assumeImaginary {
    if(args.every((a) => a.assumeZero == false && a.assumeFinite == true)) {
      return _assumeRealImagHelper(false);
    }
    return null;
  }

  bool? get _assumeHermitian => _assumeHermAntiHermHelper(true);
  bool? get _assumeAntiHermitian => _assumeHermAntiHermHelper(false);

  bool? _assumeHermAntiHermHelper(bool herm) {
    for(final t in args) {
      if(t.assumeHermitian == null || t.assumeAntiHermitian == null) {
        return null;
      }
      if(t.assumeHermitian == true) {
        continue;
      } else if(t.assumeAntiHermitian == true) {
        herm = !herm;
      } else {
        return null;
      }
    }

    if(herm != false) {
      return herm;
    }

    final isZero = _assumeZero;
    if(isZero == true) {
      return true;
    } else if(isZero == false) {
      return herm;
    }
    return null;
  }

  bool? get _assumeIrrational {
    for(final t in args) {
      final a = t.assumeIrrational;
      if(a == true) {
        final others = List<Expr>.from(args);
        others.remove(t);
        if(others.every((x) => (x.assumeRational == true && fuzzyNot(x.assumeZero) == true))) {
          return true;
        }
        return null;
      }
      if(a == null) {
        return null;
      }
    }
    if(args.every((a) => a.assumeReal == true)) {
      return false;
    }
    return null;
  }

  /// Return true if this is positive, false if not, and null if it cannot
  /// be determined.
  ///
  /// Explanation
  /// ===========
  ///
  /// This algorithm is non-recursive and works by keeping track of the
  /// sign which changes when a negative or nonpositive is encountered.
  /// Whether a nonpositive or nonnegative is seen is also tracked since
  /// the presence of these makes it impossible to return true, but
  /// possible to return false if the end result is nonpositive. e.g.
  ///
  ///     pos * neg * nonpositive -> pos or zero -> null is returned
  ///     pos * neg * nonnegative -> neg or zero -> false is returned
  ///
  bool? get _assumeExtendedPositive {
    return _assumePosNegHelper(1);
  }

  bool? get _assumeExtendedNegative {
    return _assumePosNegHelper(-1);
  }

  bool? _assumePosNegHelper(int sign) {
    bool sawNON = false;
    bool sawNOT = false;
    for(final t in args) {
      if(t.assumeExtendedPositive == true) {
        continue;
      } else if(t.assumeExtendedNegative == true) {
        sign = -sign;
      } else if(t.assumeZero == true) {
        if(args.every((a) => a.assumeFinite == true)) {
          return false;
        }
        return null;
      } else if(t.assumeExtendedNonPositive == true) {
        sign = -sign;
        sawNON = true;
      } else if(t.assumeExtendedNonNegative == true) {
        sawNON = true;
      }
      /// FIXME: assumePositive, assumeNegative is false doesn't take account
      /// of Symbol('x', infinite: true, extendedReal: true) which has
      /// e.g. assumePositive is false, but has uncertain sign.
      else if(t.assumePositive == false) {
        sign = -sign;
        if (sawNOT) {
          return null;
        }
        sawNOT = true;
      } else if(t.assumeNegative == false) {
        if(sawNOT) {
          return null;
        }
        sawNOT = true;
      } else {
        return null;
      }
    }

    if(sign == 1 && sawNON == false && sawNOT == false) {
      return true;
    }
    if(sign < 0) {
      return false;
    }
    return null;
  }

  bool? get _assumeOdd {
    final isInteger = _assumeInteger;
    if(isInteger != true) {
      return isInteger;
    }

    // TODO finish implementing _assumeOdd

    return null;
  }

  bool? get _assumeEven {
    // TODO finish implementing _assumeEven

    return null;
  }

  /// Here we count the number of arguments that have a minimum value
  /// greater than two.
  /// If there are more than one of such a symbol then the result is composite.
  /// Else, the result cannot be determined.
  bool? get _assumeComposite {
    int numberOfArgs = 0; // count of symbols with minimum value greater than oone
    for(final arg in args) {
      if(!(arg.assumeInteger == true && arg.assumePositive == true)) {
        return null;
      }
      if((arg - S.One).assumePositive == true) {
        numberOfArgs++;
      }
    }

    if(numberOfArgs > 1) {
      return true;
    }

    return null;
  }

  @override
  Expr func(List<Basic<dynamic>> args) {
    return Mul(args.cast<Expr>(), evaluate: evaluate);
  }

  /// Return the tuple (R, self/R) where R is the positive Rational
  /// extracted from self.
  @override
  (Basic, Basic) asContentPrimitive({bool radical = false, bool clear = true}) {
    Expr coef = One.instance;
    final args = <Expr>[];
    for(final a in this.args) {
      final (c, p) = a.asContentPrimitive(radical: radical, clear: clear);
      coef *= c;
      if(p is! One) {
        args.add(p as Expr);
      }
    }
    return (coef, func(args));
  }
}

Expr keepCoeff(Expr coeff, Expr factors, {bool clear = true, bool sign=false}) {
  if(!coeff.isNumber) {
    if(factors.isNumber) {
      (factors, coeff) = (coeff, factors);
    } else {
      return coeff * factors;
    }
  }
  if(factors is One) {
    return coeff;
  }
  if(coeff is One) {
    return factors;
  } else if(coeff is NegativeOne && !sign) {
    return -factors;
  } else if(factors.isAdd && factors is Add) {
    if(!clear && coeff.isRational && coeff is Rational && coeff.q != BigInt.one) {
      List<(Number, Expr)> argsRaw = [
        for(final i in factors.args)
          i.asCoeffMul(),
      ];
      final args = [
        for(final (c, m) in argsRaw)
          (keepCoeff(c, coeff), m),
      ];
      if (args.any((c) => c.$1.isInteger)) {
        return Add([
          for(final i in args)
            Mul(i.$1 is One? [i.$2] : [i.$1, i.$2]),
        ]);
      }
    }
    return Mul([coeff, factors], evaluate: false);
  } else if(factors.isMul && factors is Mul) {
    final margs = List<Expr>.from(factors.args);
    if(margs[0].isNumber && margs[0] is Number) {
      margs[0] *= coeff;
      if(margs[0] is One) {
        margs.removeAt(0);
      }
    } else {
      margs.insert(0, coeff);
    }
    return Mul(margs);
  } else {
    Expr m = coeff*factors;
    if(m.isNumber && !factors.isNumber) {
      m = Mul([coeff, factors]);
    }
    return m;
  }
}

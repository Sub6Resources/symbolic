import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/logic.dart';
import 'package:symbolic/core/mul.dart' show keepCoeff;
import 'package:symbolic/core/numbers.dart';
import 'package:symbolic/core/singleton.dart';

class Add extends Expr {
  final bool evaluate;

  Add(List<Expr> super.args, {this.evaluate = true}) {
    addAssumptions(
      real: _assumeReal,
      extendedReal: _assumeExtendedReal,
      complex: _assumeComplex,
      antiHermitian: _assumeAntiHermitian,
      finite: _assumeFinite,
      hermitian: _assumeHermitian,
      integer: _assumeInteger,
      rational: _assumeRational,
      algebraic: _assumeAlgebraic,
      commutative: _assumeCommutative,
      infinite: _assumeInfinite,
      imaginary: _assumeImaginary,
      zero: _assumeZero,
      odd: _assumeOdd,
      irrational: _assumeIrrational,
    );
  }

  @override
  List<Expr> get args => List<Expr>.from(super.args);

  @override
  bool get isAdd => true;

  // assumption methods
  bool? get _assumeReal => fuzzyGroup([for(final a in args) a.assumeReal], quickExit: true);
  bool? get _assumeExtendedReal => fuzzyGroup([for(final a in args) a.assumeExtendedReal], quickExit: true);
  bool? get _assumeComplex => fuzzyGroup([for(final a in args) a.assumeComplex], quickExit: true);
  bool? get _assumeAntiHermitian => fuzzyGroup([for(final a in args) a.assumeAntiHermitian], quickExit: true);
  bool? get _assumeFinite => fuzzyGroup([for(final a in args) a.assumeFinite], quickExit: true);
  bool? get _assumeHermitian => fuzzyGroup([for(final a in args) a.assumeHermitian], quickExit: true);
  bool? get _assumeInteger => fuzzyGroup([for(final a in args) a.assumeInteger], quickExit: true);
  bool? get _assumeRational => fuzzyGroup([for(final a in args) a.assumeRational], quickExit: true);
  bool? get _assumeAlgebraic => fuzzyGroup([for(final a in args) a.assumeAlgebraic], quickExit: true);
  bool? get _assumeCommutative => fuzzyGroup([for(final a in args) a.assumeCommutative]);

  bool? get _assumeInfinite {
    bool sawInf = false;
    for(final a in args) {
      final ainf = a.assumeInfinite;
      if(ainf == null) {
        return null;
      } else if(ainf == true) {
        // infinite+infinite might not be infinite
        if(sawInf == true) {
          return null;
        }
        sawInf = true;
      }
    }

    return sawInf;
  }

  bool? get _assumeImaginary {
    final List<Expr> nz = [];
    final List<Expr> imI = [];
    for(final a in args) {
      if(a.assumeExtendedReal == true) {
        if(a.assumeZero == true) {
          // pass
        } else if(a.assumeZero == false) {
          nz.add(a);
        } else {
          return null;
        }
      } else if(a.assumeImaginary == true) {
        imI.add(a*S.I);
      } else if(a.isMul && a.args.contains(S.I)) {
        final (coeff, ai) = a.asCoeffMulDep([S.I]);
        if (ai.length == 1 && ai[0] == S.I && coeff.assumeExtendedReal == true) {
          imI.add(-coeff);
        } else {
          return null;
        }
      } else {
        return null;
      }

      if(nz.length < args.length) {
        final b = Add(nz);
        if (b.assumeZero == true) {
          return fuzzyNot(Add(imI).assumeZero);
        } else if (b.assumeZero == false) {
          return false;
        }
      }
    }
    return null;
  }

  bool? get _assumeZero {
    if(_assumeCommutative == false) {
      // there is no way to know if a non-commutative symbol is zero or not
      return null;
    }
    final List<Expr> nz = [];
    int z = 0;
    bool imOrZ = false;
    int im = 0;
    for(final a in args) {
      if(a.assumeExtendedReal == true) {
        if (a.assumeZero == true) {
          z += 1;
        } else if(a.assumeZero == false) {
          nz.add(a);
        } else {
          return null;
        }
      } else if (a.assumeImaginary == true) {
        im += 1;
      } else if (a.isMul && a.args.contains(S.I)) {
        final (coeff, ai) = a.asCoeffMulDep([S.I]);
        if (ai.length == 1 && ai[0] == S.I && coeff.assumeExtendedReal == true) {
          imOrZ = true;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }

    if(z == args.length) {
      return true;
    }
    if(nz.isEmpty || nz.length == args.length) {
      return null;
    }
    final b = Add(nz);
    if(b.assumeZero == true) {
      if(!imOrZ) {
        if(im == 0) {
          return true;
        } else if(im == 1) {
          return false;
        }
      }
    }
    if(b.assumeZero == false) {
      return false;
    }

    return null;
  }

  bool? get _assumeOdd {
    final l = [for(final f in args) if(f.assumeEven != true) f];
    if(l.isEmpty) {
      return false;
    }
    if(l.length == 1) {
      return l[0].assumeOdd;
    }
    if(l[0].assumeOdd == true) {
      return Add(l.sublist(1)).assumeEven;
    }
    return null;
  }

  bool? get _assumeIrrational {
    for(final t in args) {
      final a = t.assumeIrrational;
      if(a == true) {
        final others = List<Expr>.from(args);
        others.remove(t);

        if(others.every((x) => x.assumeRational == true)) {
          return true;
        }
        return null;
      }
      if(a == null) {
        return null;
      }
    }
    return false;
  }

  @override
  bool couldExtractMinusSign() {
    final negativeArgs = args
        .map((e) => e.couldExtractMinusSign() ? 1 : 0)
        .reduce((a, b) => a + b);
    final positiveArgs = args.length - negativeArgs;
    if (positiveArgs > negativeArgs) {
      return false;
    } else if (positiveArgs < negativeArgs) {
      return true;
    }

    // TODO Choose based on sortKey to prefer
    // x - 1 instead of 1 - x and
    // 3 - sqrt(2) instead of -3 + sqrt(2)
    // return sortKey() < (-this).sortKey();
    return false;
  }

  void _addSort(List<Basic<dynamic>> args) {
    args.sort(compare);
  }

  @override
  Expr func(List<Basic<dynamic>> args) {
    return Add(args.cast<Expr>(), evaluate: evaluate);
  }

  /// Return `(R, this/R)` where `R` is the Rational GCD of this.
  ///
  /// R is collected only from the leading coefficient of each term.
  (Basic, Basic) primitive() {
    final rawTerms = <(BigInt, BigInt, Expr)>[];
    bool inf = false;
    for(final a in args) {
      var (c, m) = a.asCoeffMul();
      if(!c.isRational || c is! Rational) {
        c = One.instance;
        m = a;
      }
      inf = inf || m is ComplexInfinity;
      rawTerms.add((c.p, c.q, m));
    }

    BigInt ngcd = BigInt.zero;
    BigInt dlcm = BigInt.one;
    if(!inf) {
      for(final t in rawTerms) {
        ngcd = ngcd.gcd(t.$1);
        dlcm = dlcm.lcm(t.$2);
      }
    } else {
      for(final t in rawTerms) {
        if(t.$2 != BigInt.zero) {
          ngcd = ngcd.gcd(t.$1);
          dlcm = dlcm.lcm(t.$2);
        }
      }
    }

    if(ngcd == BigInt.one && dlcm == BigInt.one) {
      return (One.instance, this);
    }

    final terms = <Basic<dynamic>>[];
    if(!inf) {
      for(int i = 0; i < terms.length; i++) {
        final (p, q, term) = rawTerms[i];
        terms.add(keepCoeff(Rational((p ~/ ngcd)*(dlcm~/q)), term));
      }
    } else {
      for(int i = 0; i < terms.length; i++) {
        final (p, q, term) = rawTerms[i];
        if(q != 0) {
          terms.add(keepCoeff(Rational((p~/ngcd)*(dlcm~/q)), term));
        } else {
          terms.add(keepCoeff(Rational(p, q: q), term));
        }
      }
    }

    // We don't need a complete re-flattening since no new terms will join
    // so we just use the same sort as is used in Add.flatten. When the
    // coefficient changes, the ordering of terms may change, e.g.
    //     (3*x, 6*y) -> (2*y, x)
    //
    // We do need to make sure that term[0] stays in position 0, however.
    var c;
    if((terms[0].isNumber && terms[0] is Number) || terms[0] is ComplexInfinity) {
      c = terms.removeAt(0);
    }
    _addSort(terms);
    if(c != null) {
      terms.insert(0, c);
    }
    return (Rational(ngcd, q: dlcm), this.func(terms));
  }

  /// Return the tuple (R, this/R) where R is the positive Rational
  /// extracted from this. If radical is true (default is false) then
  /// common radicals will be removed and included as a factor of the
  /// primitive expression.
  @override
  (Basic, Basic) asContentPrimitive({bool radical = false, bool clear = true}) {
    final (con, prim) = (func([
      for(final a in args.map((ai) => ai.asContentPrimitive(radical: radical, clear: clear)))
        keepCoeff(a.$1 as Expr, a.$2 as Expr),
    ]) as Add).primitive();
    if(!clear && !con.isInteger && prim.isAdd && prim is Add) {
      throw UnimplementedError("clear branch in asContentPrimitive not implemented in Add");
    }
    if(radical && prim.isAdd && prim is Add) {
      throw UnimplementedError("radical branch in asContentPrimitive not implemented in Add");
    }
    return (con, prim);
  }
}

extension LCM on BigInt {
  BigInt lcm(BigInt other) {
    if(this == BigInt.zero || other == BigInt.zero) {
      return BigInt.zero;
    }

    return (this * other).abs() ~/ gcd(other);
  }
}

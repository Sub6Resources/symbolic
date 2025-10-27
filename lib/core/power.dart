import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/logic.dart';
import 'package:symbolic/core/singleton.dart';

class Pow extends Expr {
  final bool evaluate;

  Pow(Expr base, Expr exp, {this.evaluate = true}) : super([base, exp]) {
    addAssumptions(
      even: _assumeEven,
      negative: _assumeNegative,
      extendedPositive: _assumeExtendedPositive,
      extendedNegative: _assumeExtendedNegative,
      zero: _assumeZero,
      integer: _assumeInteger,
      extendedReal: _assumeExtendedReal,
      complex: _assumeComplex,
      imaginary: _assumeImaginary,
      odd: _assumeOdd,
      finite: _assumeFinite,
      prime: _assumePrime,
      composite: _assumeComposite,
    );
  }

  // TODO add factory that returns singleton instances in special cases

  @override
  bool get isPow => true;

  @override
  List<Expr> get args => List<Expr>.from(super.args);

  Expr get base => args[0];

  Expr get exp => args[1];

  bool? get _assumeEven {
    if(exp.assumeInteger == true && exp.assumePositive == true) {
      return base.assumeEven;
    }
    return null;
  }

  bool? get _assumeNegative {
    final extNeg = _assumeExtendedNegative;
    if(extNeg == true) {
      return _assumeFinite;
    }
    return extNeg;
  }

  bool? get _assumeExtendedPositive {
    if(base == exp) {
      if(base.assumeExtendedNonNegative == true) {
        return true;
      }
    } else if(base.assumePositive == true) {
      if(exp.assumeReal == true) {
        return true;
      }
    } else if(base.assumeExtendedNegative == true) {
      if(exp.assumeEven == true) {
        return true;
      }
      if(exp.assumeOdd == true) {
        return false;
      }
    } else if(base.assumeZero == true) {
      if(exp.assumeExtendedReal == true) {
        return exp.assumeZero;
      }
    } else if(base.assumeExtendedNonPositive == true) {
      if(exp.assumeOdd == true) {
        return false;
      }
    } else if(base.assumeImaginary == true) {
      if(exp.assumeInteger == true) {
        final m = exp % 4;
        if(m.assumeZero == true) {
          return true;
        }
        if(m.assumeInteger == true && m.assumeZero == false) {
          return false;
        }
      }
      if(exp.assumeImaginary == true) {
        // TODO import log
        // TODO return log(base).assumeImaginary;
      }
    }
    return null;
  }

  bool? get _assumeExtendedNegative {
    if(exp == S.Half) {
      if(base.assumeComplex == true || base.assumeExtendedReal == true) {
        return false;
      }
    }
    if(base.assumeExtendedNegative == true) {
      if(exp.assumeOdd == true && base.assumeFinite == true) {
        return true;
      }
      if(exp.assumeEven == true) {
        return false;
      }
    } else if(base.assumeExtendedPositive == true) {
      if(exp.assumeExtendedReal == true) {
        return false;
      }
    } else if(base.assumeZero == true) {
      if(exp.assumeExtendedReal == true) {
        return false;
      }
    } else if(base.assumeExtendedNonNegative == true) {
      if(exp.assumeExtendedNonNegative == true) {
        return false;
      }
    } else if(base.assumeExtendedNonPositive == true) {
      if(exp.assumeEven == true) {
        return false;
      }
    } else if(base.assumeExtendedReal == true) {
      if(exp.assumeEven == true) {
        return false;
      }
    }
    return null;
  }

  bool? get _assumeZero {
    if(base.assumeZero == true) {
      if(exp.assumeExtendedPositive == true) {
        return true;
      } else if(exp.assumeExtendedNonPositive == true) {
        return false;
      }
    } else if(base == S.Exp1) {
      return exp == S.NegativeInfinity;
    } else if(base.assumeZero == false) {
      if(base.assumeFinite == true && exp.assumeFinite == true) {
        return false;
      } else if(exp.assumeNegative == true) {
        return base.assumeInfinite;
      } else if(exp.assumeNonNegative == true) {
        return false;
      } else if(exp.assumeInfinite == true && exp.assumeExtendedReal == true) {
        if ((S.One - base.abs()).assumeExtendedPositive == true) {
          return exp.assumeExtendedPositive;
        } else if((S.One - base.abs()).assumeExtendedNegative == true) {
          return exp.assumeExtendedNegative;
        }
      }
    } else if(base.assumeFinite == true && exp.assumeNegative == true) {
      // when base.assumeZero == null
      return false;
    }
    return null;
  }

  bool? get _assumeInteger {
    if(base.assumeRational == true) {
      if(base.assumeInteger == false && exp.assumePositive == true) {
        return false; // rational^nonneg
      }
    }
    if(base.assumeInteger == true && exp.assumeInteger == true) {
      if(base == S.NegativeOne) {
        return true;
      }
      if(exp.assumeNonNegative == true || exp.assumePositive == true) {
        return true;
      }
    }
    if(base.assumeInteger == true && exp.assumeNegative == true && (exp.assumeFinite == true || exp.assumeInteger == true)) {
      if(fuzzyNot((base - S.One).assumeZero) == true && fuzzyNot((base + S.One).assumeZero) == true) {
        return false;
      }
    }
    if(base.isNumber && exp.isNumber) {
      final check = Pow(base, exp);
      return check.isInteger;
    }
    if(exp.assumeNegative == true && base.assumePositive == true && (base - S.One).assumePositive == true) {
      return false;
    }
    if(exp.assumeNegative == true && base.assumeNegative == true && (base + S.One).assumeNegative == true) {
      return false;
    }

    return null;
  }

  bool? get _assumeExtendedReal {
    // TODO implement (depends on log and exp functions)
    return null;
  }

  bool? get _assumeComplex {
    if(base == S.Exp1) {
      return fuzzyOr([exp.assumeComplex, exp.assumeExtendedNegative]);
    }

    if(args.every((a) => a.assumeComplex == true) && _assumeFinite == true) {
      return true;
    }

    return null;
  }

  bool? get _assumeImaginary {
    if(base.assumeCommutative == false) {
      return false;
    }

    if(base.assumeImaginary == true) {
      if(exp.assumeInteger == true) {
        final odd = exp.assumeOdd;
        if(odd != null) {
          return odd;
        }
        return null;
      }
    }

    if(base == S.Exp1) {
      final f = (exp * 2) / (S.Pi * S.ImaginaryUnit);
      // exp(pi*int) = 1 or -1, so not imaginary
      if(f.assumeEven == true) {
        return false;
      }
      // exp(pi*int + pi/2) = I or -I, so it is imaginary
      if(f.assumeOdd == true) {
        return true;
      }
      return null;
    }

    if(exp.assumeImaginary == true) {
      // TODO implement - depends on log function
    }

    if(base.assumeExtendedReal == true && exp.assumeExtendedReal == true) {
      if(base.assumePositive == true) {
        return false;
      } else {
        final rat = exp.assumeRational;
        if(rat != true) {
          return rat;
        }
        if(exp.assumeInteger == true) {
          return false;
        } else {
          final half = (exp * 2).assumeInteger;
          if(half == true) {
            return base.assumeNegative;
          }
          return half;
        }
      }
    }

    if(base.assumeExtendedReal == false) {
      // we already know it's not imag
      // TODO implement - depends on complex arg function
      // final i = arg(base)*exp/S.Pi;
      // final isOdd = (i*2).assumeOdd;
      // if(isOdd != null) {
      //   return isOdd;
      // }
    }

    return null;
  }

  bool? get _assumeOdd {
    if(exp.assumeInteger == true) {
      if(exp.assumePositive == true) {
        return base.assumeOdd;
      } else if(exp.assumeNonNegative == true && base.assumeOdd == true) {
        return true;
      } else if(base == S.NegativeOne) {
        return true;
      }
    }

    return null;
  }

  bool? get _assumeFinite {
    if(exp.assumeNegative == true) {
      if(base.assumeZero == true) {
        return false;
      }
      if(base.assumeInfinite == true || base.assumeNonzero == true) {
        return true;
      }
    }
    final c1 = base.assumeFinite;
    if(c1 == null) {
      return null;
    }
    final c2 = exp.assumeFinite;
    if(c2 == null) {
      return null;
    }
    if(c1 && c2) {
      if(exp.assumeNonNegative == true || fuzzyNot(base.assumeZero) == true) {
        return true;
      }
    }
    return null;
  }

  bool? get _assumePrime {
    // An integer raised to the n(>=2)-th power cannot be a prime.
    if(base.assumeInteger == true && exp.assumeInteger == true && (exp - S.One).assumePositive == true) {
      return false;
    }

    return null;
  }

  bool? get _assumeComposite {
    // A power is composite if both base and exponent are greater than 1
    if(base.assumeInteger == true && exp.assumeInteger == true &&
        (base - S.One).assumePositive == true && (exp - S.One).assumePositive == true ||
        (base + S.One).assumePositive == true && exp.assumePositive == true && exp.assumeEven == true) {
      return true;
    }

    return null;
  }

  @override
  Expr func(List<Basic<dynamic>> args) {
    return Pow(args[0] as Expr, args[1] as Expr);
  }

  // TODO implement
  // bool? get _assumePolar {
  //   return base.assumePolar;
  // }

  @override
  (Basic, Basic) asContentPrimitive({bool radical = false, bool clear = true}) {
    throw UnimplementedError("asContentPrimitive unimplemented for power");
  }
}

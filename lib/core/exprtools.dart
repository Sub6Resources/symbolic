import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/mul.dart' show keepCoeff;

/// Remove common factors from terms in all arguments without
///     changing the underlying structure of the expr. No expansion or
///     simplification (and no processing of non-commutatives) is performed.
///
///     Parameters
///     ==========
///
///     radical: bool, optional
///         If radical=True then a radical common to all terms will be factored
///         out of any Add sub-expressions of the expr.
///
///     clear : bool, optional
///         If clear=False (default) then coefficients will not be separated
///         from a single Add if they can be distributed to leave one or more
///         terms with integer coefficients.
///
///     fraction : bool, optional
///         If fraction=True (default is False) then a common denominator will be
///         constructed for the expression.
///
///     sign : bool, optional
///         If sign=True (default) then even if the only factor in common is a -1,
///         it will be factored out of the expression.
Expr factorTerms(
  Expr expr, {
  bool radical = false,
  clear = false,
  fraction = false,
  sign = true,
}) {
  if(expr.isAtom) {
    return expr;
  }

  if(expr.isPow || expr.isFunction) {
    final newArgs = [
      for(final a in expr.args)
        factorTerms(a as Expr, radical: radical, clear: clear, fraction: fraction, sign: sign),
    ];
    if(expr.args.asMap().entries.every((entry) => entry.value == newArgs[entry.key])) {
      return expr;
    }
    return expr.func(newArgs);
  }

  // TODO if(expr is Sum || expr is Integral) {
  //   return _factorSumInt(expr, radical: radical, clear: clear, fraction: fraction, sign: sign);
  // }

  var (cont, p) = expr.asContentPrimitive(radical: radical, clear: clear);
  if(p.isAdd) {
    throw UnimplementedError("factorTerms unimplemented if p is Add");
  } else if(p.args.isNotEmpty) {
    p = p.func([
      for(final a in p.args)
        factorTerms(a as Expr, radical: radical, clear: clear, fraction: fraction, sign: sign),
    ]);
  }
  return keepCoeff(cont as Expr, p as Expr, clear: clear, sign: sign);
}

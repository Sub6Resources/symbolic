import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/singleton.dart';

abstract interface class EvalSimplify {
  T evalSimplify<T>({double ratio = 1.7, bool inverse=false,});
}

T simplify<T>(T expr, {double ratio = 1.7, bool inverse=false,}) {
  // no routine for Expr needs to check for assumeZero
  if(expr is Expr && expr.assumeZero == true) {
    return expr.isNumber? expr: S.Zero as T;
  }

  // Check if expr has attribute evalSimplify method and call
  // that if it exists
  if(expr is EvalSimplify) {
    return expr.evalSimplify(ratio: ratio, inverse: inverse);
  }

  // TODO final originalExpr = expr = collectAbs(signSimp(expr));

  // XXX: temporary hack
  if(expr is! Basic || expr.args.isEmpty) {
    return expr;
  }

  // TODO check if expr has Function and inversecombine expr

  // TODO do deep simplification

  // TODO if not expr.is_commutative: expr = nc_simplify(expr)

  // TODO rationalize floats

  // TODO _bottom_up
  // TODO powsimp
  // TODO cancel
  // TODO shorter
  // TODO shorter together

  // TODO check ratio
  if(expr is! Basic) {
    return expr;
  }

  // TODO faactor_terms

  // TODO if expr.has(sign)

  // TODO if expr.has(Piecewise)

  // TODO hyperexpand

  // TODO if expr.has(KroneckerDelta)

  // TODO if expr.has(BesselBase)

  // TODO if expr.has((TrigonometricFunction, HyperbolicFunction)

  // TODO if expr.has(log)

  // TODO if expr.hasCombinatoricalFunction, gamma)

  // TODO if expr.has(Integral)

  // TODO if expr.has(Product)

  // TODO if expr.has(Quantity)

  // TODO shortx3

  // TODO hollow_mul

  // TODO numer, denom

  // TODO if expr.could_extract_minus_sign()

  // TODO check measure()

  // TODO restore floats

  // TODO
  return expr;
}

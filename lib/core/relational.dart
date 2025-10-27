import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/numbers.dart';
import 'package:symbolic/logic/boolalg.dart';
import 'package:symbolic/simplify/simplify.dart';
import 'package:symbolic/solvers/solveset.dart';

import 'expr.dart';

class Relational extends Boolean implements EvalSimplify {
  // TODO add EvalfMixin
  final String relOp;

  Relational(Expr lhs, Expr rhs, {required this.relOp}) : super([lhs, rhs]);

  @override
  bool get isRelational => true;

  /// The left-hand side of the relation.
  Expr get lhs => args[0] as Expr;

  /// The right-hand side of the relation.
  Expr get rhs => args[1] as Expr;

  @override
  Relational func(List<Basic<dynamic>> args) {
    return Relational(args[0] as Expr, args[1] as Expr, relOp: relOp);
  }

  @override
  T evalSimplify<T>({double ratio = 1.7, bool inverse = false}) {
    Relational r = this;
    r = r.func([
      for(final i in r.args)
        i.simplify(ratio: ratio, inverse: inverse),
    ]);

    if (r.isRelational) {
      if (r.lhs is! Expr || r.rhs is! Expr) {
        return r as T;
      }

      final dif = r.lhs - r.rhs;

      // TODO replace dif with a valid Number that will
      // allow a definitive comparison with 0
      Basic? v = null;
      //if(dif.isComparable) {
      //  // TODO
      //} else
      if (dif.equals(Zero.instance) == true) { // XXX: this is expensive
        v = Zero.instance;
      }
      if(v != null) {
        // TODO r = r.func._eval_relation(v, Zero.instance);
      }
      // TODO r = r.canonical;
      // If there is only one symbol in the expression,
      // try to write it on a simplified form
      final free = r.freeSymbols().where((x) => x.assumeReal != false).toList();
      if(free.length == 1) {
        try {
          final x = free.removeAt(0);
          final dif = r.lhs - r.rhs;
          final coeffs = linearCoeffs(dif, [x as Expr]);
          final m = coeffs[0];
          final b = coeffs[1];
          if(m.assumeZero == false) {
            if(m.assumeNegative == true) {
              // Dividing with a negative number, so change order of arguments
              // canonical will put the symbol back on the lhs later
              r = r.func([-b / m, x]);
            } else {
              r = r.func([x, -b / m]);
            }
          } else {
            r = r.func([b, Zero.instance]);
          }
        } on NonlinearException catch(e) {
          // maybe not a linear function, try polynomial
          throw UnimplementedError("Haven't implemented polynomial solvers yet in Relational ${e.runtimeType}, $e");
        }
      } else if(free.length >= 2) {
        throw UnimplementedError("Haven't implemented solvers with more than 1 variable yet in Relational");
      }
    }
    // Did we get a simplified result?
    // TODO r = r.canonical;
    // TODO measure & ratio
    return r as T;
  }
}

typedef Rel = Relational;

/// An equal relation between two objects.
///
/// Explanation
/// ===========
///
/// Represents that two objects are equal. If they can be easily shown
/// to be definitively equal (or unequal), this will reduce to True (or
/// False). Otherwise, the relation is maintained as an unevaluated
/// Equality object. Use the [simplify] function on this object for
/// more nontrivial evaluation of the equality relation.
class Equality extends Relational {
  Equality(super.lhs, super.rhs) : super(relOp: "==");
  // TODO add evaluate function

  @override
  bool get isEquality => true;
}

typedef Eq = Equality;

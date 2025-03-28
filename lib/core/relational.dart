import 'package:symbolic/logic/boolalg.dart';

import 'expr.dart';

class Relational extends Boolean {
  // TODO add EvalfMixin
  final String relOp;

  Relational(Expr lhs, Expr rhs, {required this.relOp}) : super([lhs, rhs]);

  /// The left-hand side of the relation.
  Expr get lhs => args[0] as Expr;

  /// The right-hand side of the relation.
  Expr get rhs => args[1] as Expr;
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
}

typedef Eq = Equality;

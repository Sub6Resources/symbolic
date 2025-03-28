import 'package:symbolic/core/expr.dart';

class Pow extends Expr {
  final bool evaluate;

  Pow(Expr base, Expr exp, {this.evaluate = true}) : super([base, exp]);

  // TODO add factory that returns singleton instances in special cases

  @override
  List<Expr> get args => List<Expr>.from(super.args);

  Expr get base => args[0];

  Expr get exp => args[1];
}

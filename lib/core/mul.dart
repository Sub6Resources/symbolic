import 'package:symbolic/core/expr.dart';

class Mul extends Expr {
  final bool evaluate;

  Mul(List<Expr> super.args, {this.evaluate = true});

  @override
  List<Expr> get args => List<Expr>.from(super.args);

  @override
  bool couldExtractMinusSign() {
    // TODO
    return false;
  }
}

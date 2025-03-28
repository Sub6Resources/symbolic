import 'package:symbolic/core/expr.dart';

class Add extends Expr {
  final bool evaluate;

  Add(List<Expr> super.args, {this.evaluate = true});

  @override
  List<Expr> get args => List<Expr>.from(super.args);

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

    // TODO Chose based on sortKey to prefer
    // x - 1 instead of 1 - x and
    // 3 - sqrt(2) instead of -3 + sqrt(2)
    // return sortKey() < (-this).sortKey();
    return false;
  }
}

import 'package:symbolic/core/atom.dart';

import 'basic.dart';

class Expr extends Basic {
  Expr(super.args);

  Expr operator -() {
    throw UnimplementedError();
  }

  Expr operator +(Object? other) {
    throw UnimplementedError();
  }

  Expr operator -(Object? other) {
    throw UnimplementedError();
  }

  Expr operator *(Object? other) {
    throw UnimplementedError();
  }

  Expr operator ^(Object? other) {
    throw UnimplementedError();
  }

  Expr operator /(Object? other) {
    throw UnimplementedError();
  }

  Expr operator %(Object? other) {
    throw UnimplementedError();
  }

  Expr operator ~/(Object? other) {
    throw UnimplementedError();
  }
}

class AtomicExpr extends Expr implements Atom {
  AtomicExpr() : super([]);
}

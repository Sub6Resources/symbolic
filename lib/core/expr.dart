import 'package:symbolic/core/atom.dart';

import 'basic.dart';

class Expr extends Basic {
  Expr(super.args);

  Basic operator -() {
    throw UnimplementedError();
  }

  Basic operator +(Basic other) {
    throw UnimplementedError();
  }

  Basic operator -(Basic other) {
    throw UnimplementedError();
  }

  Basic operator *(Basic other) {
    throw UnimplementedError();
  }

  Basic operator ^(Basic other) {
    throw UnimplementedError();
  }

  Basic operator /(Basic other) {
    throw UnimplementedError();
  }

  Basic operator %(Basic other) {
    throw UnimplementedError();
  }

  Basic operator ~/(Basic other) {
    throw UnimplementedError();
  }
}

class AtomicExpr extends Expr implements Atom {
  AtomicExpr(): super([]);
}
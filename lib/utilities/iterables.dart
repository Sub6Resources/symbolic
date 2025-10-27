import 'package:symbolic/core/symbol.dart';

/// Generate an infinite stream of Symbols consisting of a prefix and
/// increasing subscripts provided that they do not occur in [exclude].
Iterable<Symbol> numberedSymbols({String prefix='x', int start=0, Set<Symbol> exclude = const {}}) sync* {
  while(true) {
    final name = '$prefix$start';
    final s = Symbol(name);
    if(!exclude.contains(s)) {
      yield s;
    }
    start += 1;
  }
}
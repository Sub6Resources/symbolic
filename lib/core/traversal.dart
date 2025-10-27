import 'basic.dart' show Basic;

/// Yield the args of a [Basic] object in a breadth-first traversal.
/// Depth-traversal stops if `arg.args` is either empty or is not
/// an iterable.
Iterable<Basic<dynamic>> iterArgs(Basic<dynamic> expr) sync* {
  final args = [expr];
  for(final i in args) {
    yield i;
    args.addAll(i.args);
  }
}

/// Yield the args of a Basic object in a breadth-first traversal.
/// Depth-traversal stops if `arg.args` is either empty or is not
/// an iterable. The bound objects of an expression will be returned
/// as canonical variables.
Iterable<Basic<dynamic>> iterFreeArgs(Basic<dynamic> expr, {bool first = true}) sync* {
  List<Basic<dynamic>> args = [expr];
  for(final i in args) {
    yield i;
    if(first) {
      final _void = i.canonicalVariables.values;
      for(final i in iterFreeArgs(i.asDummy(), first: false)) {
        if(!i.has(_void.toList())) {
          yield i;
        }
      }
    }
    args.addAll(i.args);
  }
}

Iterable<Basic<dynamic>> postorderTraversal(Basic<dynamic> node) sync* {
  for(final arg in node.args) {
    yield* postorderTraversal(arg);
  }
  yield node;
}

/// Zip two iterables together, yielding pairs of elements.
/// If one iterable is shorter, use [fillA] or [fillB] to fill
/// in the missing values (default null).
Iterable<(T?, U?)> zipLongest<T, U>(Iterable<T> a, Iterable<U> b, {T? fillA, U? fillB}) sync* {
  final ita = a.iterator;
  final itb = b.iterator;
  bool hasA = ita.moveNext();
  bool hasB = itb.moveNext();
  while(hasA || hasB) {
    yield (hasA? ita.current: fillA, hasB? itb.current: fillB);
    hasA = ita.moveNext();
    hasB = itb.moveNext();
  }
}
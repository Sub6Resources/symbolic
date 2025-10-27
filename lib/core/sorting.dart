import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/numbers.dart';

class SortKey implements Comparable<SortKey> {

  final (int, int, String) classKey;
  final int argsLength;
  final List<dynamic> args;
  final SortKey exponentKey;
  final dynamic coefficient;

  const SortKey({
    required this.classKey,
    required this.argsLength,
    required this.args,
    required this.exponentKey,
    required this.coefficient,
  });

  @override
  int compareTo(SortKey other) {
    // First compare classKey
    if (classKey != other.classKey) {
      if(classKey.$1 != other.classKey.$1) {
        return classKey.$1.compareTo(other.classKey.$1);
      } else if(classKey.$2 != other.classKey.$2) {
        return classKey.$2.compareTo(other.classKey.$2);
      } else {
        return classKey.$3.compareTo(other.classKey.$3);
      }
    }

    // Then compare argsLength
    if (argsLength != other.argsLength) {
      return argsLength.compareTo(other.argsLength);
    }

    // Then compare args
    for (int i = 0; i < argsLength; i++) {
      final a = args[i];
      if (i >= other.argsLength) {
        return 1; // this has more args, so it's greater
      }
      final b = other.args[i];
      if (a is SortKey && b is SortKey) {
        final cmp = a.compareTo(b);
        if (cmp != 0) {
          return cmp;
        }
      } else if (a is Comparable && b is Comparable) {
        final cmp = a.compareTo(b);
        if (cmp != 0) {
          return cmp;
        }
      } else {
        throw ArgumentError("Cannot compare args of type ${a.runtimeType} and ${b.runtimeType}");
      }
    }

    // Now compare exponentKey
    final expCmp = exponentKey.compareTo(other.exponentKey);
    if (expCmp != 0) {
      return expCmp;
    }

    // Finally compare coefficient
    if (coefficient is SortKey && other.coefficient is SortKey) {
      return (coefficient as SortKey).compareTo(other.coefficient as SortKey);
    }

    if (coefficient is Comparable && other.coefficient is Comparable) {
      return (coefficient as Comparable).compareTo(other.coefficient as Comparable);
    }

    throw ArgumentError("Cannot compare coefficients of type ${coefficient.runtimeType} and ${other.coefficient.runtimeType}");
  }
}

SortKey defaultSortKey<T>(T e, {String? order}) {
  if(e is Basic) {
    return e.sortKey(order: order);
  }

  List<SortKey> args;
  if(e is Map || e is Set || e is Iterable) {
    List rawArgs;
    bool unordered;
    if (e is Map) {
      rawArgs = e.keys.toList();
      unordered = true;
    } else if (e is Set) {
      rawArgs = e.toList();
      unordered = true;
    } else if (e is Iterable) {
      rawArgs = e.toList();
      unordered = false;
    } else {
      rawArgs = [];
      unordered = false;
    }
    args = rawArgs.map((e) => defaultSortKey(e, order: order)).toList();
    if(unordered) {
      args.sort();
    }

    return SortKey(
      classKey: (10, 0, e.runtimeType.toString()),
      argsLength: args.length,
      args: args,
      exponentKey: One.instance.sortKey(),
      coefficient: One.instance,
    );
  } else {
    if(e is! String) {
      throw ArgumentError("Cannot create sort key for type ${e.runtimeType}");
    } else {
      return SortKey(
        classKey: (0, 0, e.runtimeType.toString()),
        argsLength: 1,
        args: [e],
        exponentKey: One.instance.sortKey(),
        coefficient: One.instance,
      );
    }
  }
}

num _nodeCount(Basic<dynamic> e) {
  // TODO check if e is Float
  if(e.isFloat) {
    return 0.5;
  }

  return 1 + e.args.map((e) => _nodeCount(e)).fold(0, (a, b) => a + b);
}

num nodes<T>(T e) {
  if(e is Basic) {
    // TODO check if e is Derivative
    return _nodeCount(e);
  } else if(e is Iterable) {
    return 1 + e.map((e) => nodes(e)).fold(0, (a, b) => a + b);
  } else if(e is Map) {
    return 1 + e.entries.map((e) => nodes(e.key) + nodes(e.value)).fold(0, (a, b) => a + b);
  } else {
    return 1;
  }
}

Iterable<T> ordered<T>(Iterable<T> seq, List<dynamic Function(T)>? keys, {bool defaultKeys=true, bool warn=false}) sync* {
  final d = <dynamic, List<T>>{};
  if(keys != null) {
    final f = keys.removeAt(0);
    for(final a in seq) {
      final fa = f(a);
      if(!d.containsKey(fa)) {
        d[fa] = [];
      }
      d[fa]!.add(a);
    }
  } else {
    if(!defaultKeys) {
      throw ArgumentError("If defaultKeys is false, keys must be provided");
    }
    if(!d.containsKey(null)) {
      d[null] = [];
    }
    d[null]!.addAll(seq);
  }

  for(final k in d.keys.toList()..sort()) {
    var value = d[k];
    if (value!.length > 1) {
      if(keys != null) {
        value = ordered(value, keys, defaultKeys: defaultKeys, warn: warn).toList();
      } else if(defaultKeys) {
        value = ordered(value, [nodes, defaultSortKey], defaultKeys: false, warn: warn).toList();
      } else if(warn) {
        final u = value.toSet().toList();
        if(u.length > 1) {
          throw ArgumentError("Not enough keys to break ties: $u");
        }
      }
    }
    yield* value;
  }
}
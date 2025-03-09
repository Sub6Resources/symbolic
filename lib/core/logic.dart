import 'dart:math';
import 'package:symbolic/utils/list_equals.dart';

// Logic expressions handling
//
// NOTE
// ----
// At present this is mainly needed for facts.dart; feel free to improve
// this stuff for general purpose.

/// Logical expression
sealed class Logic implements Comparable<Logic> {
  final List<Logic> args;

  Logic(this.args);

  @override
  int get hashCode => Object.hashAll([runtimeType.toString(), ...args]);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    } else {
      return listEquals((other as Logic).args, args);
    }
  }

  bool operator <(Logic other) {
    return compareTo(other) == -1;
  }

  bool operator >(Logic other) {
    return compareTo(other) == 1;
  }

  @override
  int compareTo(Logic other) {
    if (runtimeType != other.runtimeType) {
      final a = runtimeType.toString();
      final b = other.runtimeType.toString();
      return a.compareTo(b);
    } else {
      final a = args;
      final b = other.args;
      // The following is equivalent to tuple comparison in Python
      for (int i = 0; i < min(a.length, b.length); i++) {
        final cmp = a[i].compareTo(b[i]);
        if (cmp != 0) {
          return cmp;
        }
      }
      return a.length.compareTo(b.length);
    }
  }

  @override
  String toString() {
    return "$runtimeType(${args.join(", ")})";
  }

  /// Logic from string with space around & and | but none after !.
  ///
  /// e.g.
  ///
  /// !a & b | c
  factory Logic.fromString(String text) {
    Logic? lExpr; // current logical expression
    String? schedOp; // scheduled operation
    for (String term in text.split(" ")) {
      // operation symbol
      if ("&|".contains(term)) {
        if (schedOp != null) {
          throw FormatException("double op forbidden: $term $schedOp");
        }
        if (lExpr == null) {
          throw FormatException(
              "$term cannot be in the beginning of expression");
        }
        schedOp = term;
        continue;
      }
      if (term.contains("&") || term.contains("|")) {
        throw FormatException("& and | must have space around them");
      }

      late final Logic logicTerm;
      if (term[0] == "!") {
        if (term.length == 1) {
          throw FormatException("do not include space after '!'");
        }
        logicTerm = Not.create(LogicAtom(term.substring(1)));
      } else {
        logicTerm = LogicAtom(term);
      }

      // already scheduled operation, e.g. '&'
      if (schedOp != null) {
        lExpr = switch (schedOp) {
          '&' => And.fromList([if (lExpr != null) lExpr, logicTerm]),
          '|' => Or.fromList([if (lExpr != null) lExpr, logicTerm]),
          String() =>
            throw UnimplementedError("Operator $schedOp is not supported"),
        };
        schedOp = null;
        continue;
      }

      // this should be atom
      if (lExpr != null) {
        throw FormatException("missing op between '$lExpr' and '$term'");
      }

      lExpr = logicTerm;
    }

    // let's check that we ended up in correct state
    if (schedOp != null) {
      throw FormatException("premature end-of-expression in '$text'");
    }
    if (lExpr == null) {
      throw FormatException("'$text' is empty");
    }

    // everything looks good now
    return lExpr;
  }

  Logic expand() {
    return this;
  }
}

class True extends Logic {
  True() : super([]);

  @override
  int get hashCode => true.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is True) {
      return true;
    } else if (other is bool?) {
      return other == true;
    }
    return false;
  }

  @override
  String toString() {
    return "True()";
  }
}

class False extends Logic {
  False() : super([]);

  @override
  int get hashCode => false.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is False) {
      return true;
    } else if (other is bool?) {
      return other == false;
    }
    return false;
  }

  @override
  String toString() {
    return "False()";
  }
}

class LogicAtom extends Logic {
  final String name;
  LogicAtom(this.name) : super([]);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is LogicAtom) {
      return name == other.name;
    } else if (other is String) {
      return name == other;
    }
    return false;
  }

  @override
  String toString() {
    return "LogicAtom('$name')";
  }

  @override
  int compareTo(Logic other) {
    if (other is! LogicAtom) {
      return super.compareTo(other);
    }
    return name.compareTo(other.name);
  }
}

class And extends Logic {
  And._(super.args);

  static Logic fromList(List<Logic> args) {
    final bArgs = <Logic>[];
    for (final a in args) {
      if (a is False) {
        return a;
      } else if (a is True) {
        continue; // skip this argument
      }
      bArgs.add(a);
    }

    final sortedArgs = And.flatten(bArgs).toSet().toList()
      ..sort((l1, l2) => l1.hashCode.compareTo(l2.hashCode));

    for (final a in sortedArgs) {
      if (sortedArgs.contains(Not.create(a))) {
        return False();
      }
    }

    if (sortedArgs.length == 1) {
      return sortedArgs.first;
    } else if (sortedArgs.isEmpty) {
      return True();
    }

    return And._(sortedArgs);
  }

  static List<Logic> flatten(List<Logic> args) {
    final argsQueue = List<Logic>.from(args);
    final res = <Logic>[];

    while (argsQueue.isNotEmpty) {
      final arg = argsQueue.removeAt(0);
      if (arg is And) {
        argsQueue.addAll(arg.args);
        continue;
      }
      res.add(arg);
    }

    return res;
  }

  Logic _evalPropagateNot() {
    // !(a&b&c ...) == !a | !b | !c ...
    return Or.fromList([
      for (final a in args) Not.create(a),
    ]);
  }

  /// (a|b|...) & c == (a&c) | (b&c) | ...
  @override
  Logic expand() {
    // first locate r
    for (int i = 0; i < args.length; i++) {
      final arg = args[i];
      if (arg is Or) {
        final aRest = args.sublist(0, i) + args.sublist(i + 1);
        final orTerms = [
          for (final a in arg.args) And.fromList([...aRest, a]),
        ];
        for (int j = 0; j < orTerms.length; j++) {
          if (orTerms[j] is And) {
            orTerms[j] = (orTerms[j] as And).expand();
          }
        }
        return Or.fromList(orTerms);
      }
    }

    return this;
  }
}

class Or extends Logic {
  Or._(super.args);

  static Logic fromList(List<Logic> args) {
    final bArgs = <Logic>[];
    for (final a in args) {
      if (a is True) {
        return a;
      } else if (a is False) {
        continue; // skip this argument
      }
      bArgs.add(a);
    }

    final sortedArgs = Or.flatten(bArgs).toSet().toList()
      ..sort((l1, l2) => l1.hashCode.compareTo(l2.hashCode));

    for (final a in sortedArgs) {
      if (sortedArgs.contains(Not.create(a))) {
        return True();
      }
    }

    if (sortedArgs.length == 1) {
      return sortedArgs.first;
    } else if (sortedArgs.isEmpty) {
      return False();
    }

    return Or._(sortedArgs);
  }

  static List<Logic> flatten(List<Logic> args) {
    final argsQueue = List<Logic>.from(args);
    final res = <Logic>[];

    while (argsQueue.isNotEmpty) {
      final arg = argsQueue.removeAt(0);
      if (arg is Or) {
        argsQueue.addAll(arg.args);
        continue;
      }
      res.add(arg);
    }

    return res;
  }

  Logic _evalPropagateNot() {
    return And.fromList([
      for (final a in args) Not.create(a),
    ]);
  }
}

class Not extends Logic {
  Not._(Logic arg) : super([arg]);

  static Logic create(Logic arg) {
    return switch (arg) {
      LogicAtom() => Not._(arg),
      True() => False(),
      False() => True(),
      Not() => arg.arg,
      // XXX this is a hack to expand right from the beginning
      And() => arg._evalPropagateNot(),
      Or() => arg._evalPropagateNot(),
    };
  }

  Logic get arg => args[0];
}

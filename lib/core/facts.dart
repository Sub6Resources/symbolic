import 'package:symbolic/core/logic.dart';
import 'package:symbolic/utils/default_map.dart';

Logic _baseFact(Logic atom) {
  if (atom is Not) {
    return atom.arg;
  } else {
    return atom;
  }
}

(Logic, bool) _asPair(Logic atom) {
  if (atom is Not) {
    return (atom.arg, false);
  } else {
    return (atom, true);
  }
}

/// Computes the transitive closure of a list of implications
///
/// Uses Warshall's algorithm, as described at
/// http://www.cs.hope.edu/~cusack/Notes/Notes/DiscreteMath/Warshall.pdf.
Set<(Logic, Logic)> transitiveClosure(List<(Logic, Logic)> implications) {
  final Set<(Logic, Logic)> fullImplications = implications.toSet();
  final literals = fullImplications
      .map((i) => <Logic>{i.$1, i.$2})
      .fold(<dynamic>{}, (s, e) => s.union(e));

  for (final k in literals) {
    for (final i in literals) {
      if (fullImplications.contains((i, k))) {
        for (final j in literals) {
          if (fullImplications.contains((k, j))) {
            fullImplications.add((i, j));
          }
        }
      }
    }
  }

  return fullImplications;
}

/// deduce all implications
///
/// Description by example
/// ----------------------
///
/// given set of logic rules:
///
///   a -> b
///   b -> c
///
/// we deduce all possible rules:
///
///   a -> b, c
///   b -> c
///
/// implications: [] of (a,b)
/// return:       {} of a -> set([b, c, ...])
DefaultMap<Logic, Set<Logic>> deduceAlphaImplications(
    List<(Logic, Logic)> implications) {
  implications += [
    for (final (i, j) in implications) (Not.create(j), Not.create(i))
  ];
  final res = DefaultMap<Logic, Set<Logic>>(() => <Logic>{});
  final fullImplications = transitiveClosure(implications);
  for (final (a, b) in fullImplications) {
    if (a == b) {
      continue; // skip a->a cyclic input
    }

    if (!res.containsKey(a)) {
      res[a] = <Logic>{};
    }
    res[a].add(b);
  }

  // clean up tautologies and check consistency
  for (final entry in res.entries) {
    final (a, impl) = (entry.key, entry.value);
    impl.remove(a);
    final na = Not.create(a);
    if (impl.contains(na)) {
      throw ArgumentError(
        "implications are inconsistent: $a -> $na $impl",
      );
    }
  }

  return res;
}

/// apply additional beta-rules (And conditions) to already-built
/// alpha implication tables
///
/// e.g.
///
/// alphaImplications:
///
/// a -> [b, !c, d]
/// b -> [d]
/// ...
///
/// betaRules:
/// &(b,d) -> e
///
/// then we'll extend a's rule to the following
/// a -> [b, !c, d, e]
Map<Logic, (Set<Logic>, List<int>)> applyBetaToAlphaRoute(
    DefaultMap<Logic, Set<Logic>> alphaImplications,
    List<(Logic, Logic)> betaRules) {
  final Map<Logic, (Set<Logic>, List<int>)> xImpl = {};
  for (final x in alphaImplications.keys) {
    xImpl[x] = (alphaImplications[x].toSet(), <int>[]);
  }
  for (final (bCond, _) in betaRules) {
    for (final bk in bCond.args) {
      if (xImpl.containsKey(bk)) {
        continue;
      }
      xImpl[bk] = (<Logic>{}, <int>[]);
    }
  }

  // static extensions to alpha rules:
  // A: x -> a,b   B: &(a,b) -> c  ==>  A: x -> a,b,c
  bool seenStaticExtension = true;
  while (seenStaticExtension) {
    seenStaticExtension = false;

    for (final (bCond, bImpl) in betaRules) {
      if (bCond is! And) {
        throw ArgumentError("Cond is not And");
      }
      final bArgs = bCond.args.toSet();
      for (final entry in xImpl.entries) {
        final (x, value) = (entry.key, entry.value);
        final (xImpls, bb) = value;
        final xAll = xImpls.union({x});
        // A: ... -> a   B: &(...) -> a  is non-informative
        if (!xAll.contains(bImpl) && xAll.containsAll(bArgs)) {
          xImpls.add(bImpl);

          // we introduced new implication - now we have to restore
          // completeness of the whole set.
          final bImplImpl = xImpl[bImpl];
          if (bImplImpl != null) {
            xImpls.addAll(bImplImpl.$1);
          }
          seenStaticExtension = true;
        }
      }
    }
  }

  // attach beta-nodes which can be possibly triggered by an alpha-chain
  for (int bIdx = 0; bIdx < betaRules.length; bIdx++) {
    final (bCond, bImpl) = betaRules[bIdx];
    final bArgs = bCond.args.toSet();
    for (final entry in xImpl.entries) {
      final (x, value) = (entry.key, entry.value);
      final (xImpls, bb) = value;
      final xAll = xImpls.union({x});
      // A: ... -> a   B: &(...) -> a      (non-informative)
      if (xAll.contains(bImpl)) {
        continue;
      }
      // A: x -> a...  B: &(!a,...) -> ... (will never trigger)
      // A: x -> a...  B: &(...) -> !a     (will never trigger)
      if ([
        for (final xi in xAll)
          (bArgs.contains(Not.create(xi)) || bImpl == Not.create(xi))
      ].any((b) => b)) {
        continue;
      }

      if (bArgs.intersection(xAll).isNotEmpty) {
        bb.add(bIdx);
      }
    }
  }

  return xImpl;
}

/// build prerequisites table from rules
///
/// Description by example
/// ----------------------
///
/// given set of logic rules:
///
///   a -> b, c
///   b -> c
///
/// we build prerequisites (from what points something can be deduced):
///
///   b <- a
///   c <- a, b
///
/// rules:   {} of a -> [b, c, ...]
/// return:  {} of c <- [a, b, ...]
///
/// Note however, that these prerequisites may *not* be enough to prove a
/// fact. An example is 'a -> b' rule, where prereq(a) is b, and prereq(b)
/// is a. That's because a=T -> b=T, and b=F -> a=F, but a=F -> b=?
DefaultMap<Logic, Set<Logic>> rules2Prereq(
    DefaultMap<(Logic, bool), Set<(Logic, bool)>> rules) {
  final prereq = DefaultMap<Logic, Set<Logic>>(() => <Logic>{});
  for (final entry in rules.entries) {
    final (key, impl) = (entry.key, entry.value);
    var (a, _) = key;
    if (a is Not) {
      a = a.arg;
    }
    for (var (i, _) in impl) {
      if (i is Not) {
        i = i.arg;
      }
      if (!prereq.containsKey(i)) {
        prereq[i] = <Logic>{};
      }
      prereq[i].add(a);
    }
  }
  return prereq;
}

//////////////////
// RULES PROVER //
//////////////////

/// (internal) Prover uses it for reporting detected tautology
class _TautologyDetected implements Exception {
  final Logic a;
  final Logic b;
  final String reason;

  _TautologyDetected(this.a, this.b, this.reason);

  @override
  String toString() {
    return "Tautology detected: $a -> $b because $reason";
  }
}

/// ai - prover of logic rules
///
/// given a set of initial rules, Prover tries to prove all possible rules
/// which follow from given premises.
///
/// As a result provedRules are always in one of two forms: alpha or beta:
///
/// Alpha rules
/// -----------
/// These are rules of the form::
///
///   a -> b & c & d & ...
///
/// Beta rules
/// ----------
/// These aare rules of the form::
///
///   &(a,b,...) -> c & d & ...
///
///
/// i.e. beta rules are join conditions that say that something follows when
/// *several* facts are true at the same time.
class Prover {
  final List<(Logic, Logic)> provedRules = [];
  final Set<(Logic, Logic)> _rulesSeen = {};
  Prover();

  (List<(Logic, Logic)>, List<(Logic, Logic)>) splitAlphaBeta() {
    final rulesAlpha = <(Logic, Logic)>[];
    final rulesBeta = <(Logic, Logic)>[];
    for (final (a, b) in provedRules) {
      if (a is And) {
        rulesBeta.add((a, b));
      } else {
        rulesAlpha.add((a, b));
      }
    }
    return (rulesAlpha, rulesBeta);
  }

  List<(Logic, Logic)> get rulesAlpha => splitAlphaBeta().$1;

  List<(Logic, Logic)> get rulesBeta => splitAlphaBeta().$2;

  /// Process a -> b rule
  void processRule(Logic a, Logic b) {
    if (_rulesSeen.contains((a, b))) {
      return;
    } else {
      _rulesSeen.add((a, b));
    }

    // this is the core of processing
    try {
      _processRule(a, b);
    } on _TautologyDetected {
      // ignore
    }
  }

  void _processRule(Logic a, Logic b) {
    // right part first

    // a -> b & c    --> a -> b  ;  a -> c
    // FIXME this is only correct when b & c != null
    if (b is And) {
      final sortedBArgs = List<Logic>.from(b.args)
        ..sort((a, b) => a.toString().compareTo(b.toString()));
      for (final bArg in sortedBArgs) {
        processRule(a, bArg);
      }
    }

    // a -> b | c    -->  !b & !c -> !a
    //               -->   a & !b -> c
    //               -->   a & !b -> b
    else if (b is Or) {
      final sortedBArgs = List<Logic>.from(b.args)
        ..sort((a, b) => a.toString().compareTo(b.toString()));
      // detect tautology first
      if (a is LogicAtom) {
        // tautology:  a -> a|c|...
        if (sortedBArgs.contains(a)) {
          throw _TautologyDetected(a, b, "a -> a|c|...");
        }
      }
      processRule(And.fromList([for (final bArg in b.args) Not.create(bArg)]),
          Not.create(a));

      for (int bIdx = 0; bIdx < sortedBArgs.length; bIdx++) {
        final bArg = sortedBArgs[bIdx];
        final bRest =
            sortedBArgs.sublist(0, bIdx) + sortedBArgs.sublist(bIdx + 1);
        processRule(And.fromList([a, Not.create(bArg)]), Or.fromList(bRest));
      }
    }

    // left part

    // a & b -> c    -->  IRREDUCIBLE CASE -- WE STORE IT AS IS
    //                    (this will be the basis of beta-network)
    else if (a is And) {
      final sortedAArgs = List<Logic>.from(a.args)
        ..sort((a, b) => a.toString().compareTo(b.toString()));
      if (sortedAArgs.contains(b)) {
        throw _TautologyDetected(a, b, "a & b -> a");
      }
      provedRules.add((a, b));
      // XXX NOTE at present we ignore !c -> !a | !b
    } else if (a is Or) {
      final sortedAArgs = List<Logic>.from(a.args)
        ..sort((a, b) => a.toString().compareTo(b.toString()));
      if (sortedAArgs.contains(b)) {
        throw _TautologyDetected(a, b, "a | b -> a");
      }
      for (final aArg in sortedAArgs) {
        processRule(aArg, b);
      }
    } else {
      // both `a` and `b` are atoms
      provedRules.add((a, b)); //  a ->  b
      provedRules.add((Not.create(b), Not.create(a))); // !b -> !a
    }
  }
}

/// Rules that describe how to deduce facts in logic space
///
/// When defined, these rules allow implications to quickly be determined
/// for a set of facts. For this precomputed deduction tables are used.
/// see [deduceAllFacts]    (forward-chaining)
///
/// Also it is possible to gather prerequisites for a fact, which is tried
/// to be proven.    (backward-chaining)
///
///
/// Definition Syntax
/// -----------------
///
/// a -> b       -- a=T -> b=T  (and automatically b=F -> a=F)
/// a -> !b      -- a=T -> b=F
/// a == b       -- a -> b & b -> a
/// a -> b & c   -- a=T -> b=T & c=T
///
///
/// Internals
/// ---------
///
/// `.fullImplications[(k, v)]`: all the implications of the fact k=v
/// `.betaTriggers[(k, v)]`: beta rules that might be triggered when k=v
///
/// `.prereq`  -- {} k <- [] of k's prerequisites
/// `.definedFacts` -- set of defined fact names
class FactRules {
  late final List<(Set<(Logic, bool)>, (Logic, bool))> betaRules;
  late final Set<Logic> definedFacts;
  final fullImplications =
      DefaultMap<(Logic, bool), Set<(Logic, bool)>>(() => <(Logic, bool)>{});
  final betaTriggers = DefaultMap<(Logic, bool), List<int>>(() => <int>[]);
  final prereq = DefaultMap<Logic, Set<Logic>>(() => <Logic>{});

  FactRules(List<String> rules) {
    // --- parse and process rules ---
    final p = Prover();
    for (final rule in rules) {
      final split = rule.split(RegExp(r"\s+"));
      final (aRaw, op, bRaw) = (split[0], split[1], split.sublist(2).join(' '));

      final a = Logic.fromString(aRaw);
      final b = Logic.fromString(bRaw);

      if (op == "->") {
        p.processRule(a, b);
      } else if (op == "==") {
        p.processRule(a, b);
        p.processRule(b, a);
      } else {
        throw ArgumentError("Unknown operator $op");
      }
    }

    // --- build deduction networks ---
    betaRules = [
      for (final (bCond, bImpl) in p.rulesBeta)
        (
          {
            for (final a in bCond.args) _asPair(a),
          },
          _asPair(bImpl),
        ),
    ];

    // deduce alpha implications
    final implA = deduceAlphaImplications(p.rulesAlpha);

    // now:
    // - apply beta rules to alpha chains  (static extension), and
    // - further associate beta rules to alpha chain (for inference
    //    at runtime)
    final implAB = applyBetaToAlphaRoute(implA, p.rulesBeta);

    // extract defined fact names
    definedFacts = {
      for (final k in implAB.keys) _baseFact(k),
    };

    // build rels (forward chains)
    for (final entry in implAB.entries) {
      final k = entry.key;
      final (impl, betaIdxs) = entry.value;
      fullImplications[_asPair(k)] = {
        for (final i in impl) _asPair(i),
      };
      betaTriggers[_asPair(k)] = betaIdxs;
    }

    // build prereq (backward chains)
    final relPrereq = rules2Prereq(fullImplications);
    relPrereq.forEach((k, pItems) {
      if (!prereq.containsKey(k)) {
        prereq[k] = <Logic>{};
      }
      prereq[k].addAll(pItems);
    });
  }

  FactRules.pregenerated(
    this.betaRules,
    this.definedFacts,
    Map<(Logic, bool), Set<(Logic, bool)>> fullImplications,
    Map<(Logic, bool), List<int>> betaTriggers,
    Map<Logic, Set<Logic>> prereq,
  ) {
    this.fullImplications.addAll(fullImplications);
    this.betaTriggers.addAll(betaTriggers);
    this.prereq.addAll(prereq);
  }

  Iterable<String> _definedFactLines() sync* {
    yield "final definedFacts = [";
    for (final fact in definedFacts.toList()..sort()) {
      yield "  ${fact.toString()},";
    }
    yield "]; // definedFacts";
  }

  Iterable<String> _fullImplicationsLines() sync* {
    yield "final fullImplications = {";
    for (final fact in definedFacts.toList()..sort()) {
      for (final value in [true, false]) {
        yield "  // Implications of $fact = $value:";
        yield "  ($fact, $value): <(Logic, bool)>{";
        final implications = fullImplications[(fact, value)];
        for (final implied in implications.toList()..sort(LogicBoolSort.sort)) {
          yield "    ${implied.toString()},";
        }
        yield "  },";
      }
    }
    yield "}; // fullImplications";
  }

  Iterable<String> _prereqLines() sync* {
    yield "final prereq = {";
    yield "";
    for (final fact in prereq.keys.toList()..sort()) {
      yield "  // facts that could determine the value of $fact";
      yield "  $fact: {";
      for (final pFact in prereq[fact].toList()..sort()) {
        yield "    $pFact,";
      }
      yield "  },";
      yield "";
    }
    yield "}; // prereq";
  }

  Iterable<String> _betaRulesLines() sync* {
    final reverseImplications =
        DefaultMap<(Logic, bool), List<(Set<(Logic, bool)>, int)>>(
            () => const []);
    for (int n = 0; n < betaRules.length; n++) {
      final (pre, implied) = betaRules[n];
      if (!reverseImplications.containsKey(implied)) {
        reverseImplications[implied] = [];
      }
      reverseImplications[implied].add((pre, n));
    }

    yield "// Note: the order of the beta rules is used in the betaTriggers";
    yield "final betaRules = [";
    yield "";
    int m = 0;
    final indices = {};
    for (final implied in reverseImplications.keys.toList()
      ..sort(LogicBoolSort.sort)) {
      final (fact, value) = implied;
      yield "  // Rules implying $fact = $value";
      for (final item in reverseImplications[implied]) {
        final (pre, n) = item;
        indices[n] = m;
        m += 1;
        final setStr = (pre.toList()..sort(LogicBoolSort.sort))
            .map((t) => t.toString())
            .join(", ");
        yield "  ({$setStr},";
        yield "    $implied),";
      }
      yield "";
    }
    yield "]; // betaRules";

    yield "final betaTriggers = {";
    for (final query in betaTriggers.keys.toList()..sort(LogicBoolSort.sort)) {
      final triggers = [
        for (final n in betaTriggers[query]) indices[n],
      ];
      yield "  $query: <int>$triggers,";
    }
    yield "}; // betaTriggers";
  }

  Iterable<String> printRules() sync* {
    yield "import 'facts.dart';";
    yield "import 'logic.dart';";
    yield "";
    yield* _definedFactLines();
    yield "";
    yield "";
    yield* _fullImplicationsLines();
    yield "";
    yield "";
    yield* _prereqLines();
    yield "";
    yield "";
    yield* _betaRulesLines();
    yield "";
    yield "";
    yield "final factRules = FactRules.pregenerated(";
    yield "    betaRules,";
    yield "    definedFacts.toSet(),";
    yield "    fullImplications,";
    yield "    betaTriggers,";
    yield "    prereq,";
    yield ");";
  }

  String toDart() {
    return printRules().join("\n");
  }
}

class InconsistentAssumptions<K, V> implements Exception {
  final FactKB kb;
  final K fact;
  final V value;

  InconsistentAssumptions(this.kb, this.fact, this.value);

  @override
  String toString() {
    return "$kb, $fact=$value";
  }
}

/// A simple propositional knowledge base relying on compiled inference rules.
class FactKB {
  final FactRules rules;
  final Map<Logic, bool?> _entries = {};

  FactKB(this.rules);

  @override
  String toString() {
    return "{\n${(_entries.entries.toList()..sort()).map((e) => "\t${e.key}: ${e.value}").join(",\n")}}";
  }

  bool? operator [](Object? key) {
    return _entries[key];
  }

  void operator []=(Logic key, bool value) {
    _entries[key] = value;
  }

  Map<Logic, bool?> toMap() {
    return _entries;
  }

  /// Add fact k=v to the knowledge base.
  ///
  /// Returns true if the KB has actually been updated, false otherwise.
  bool _tell(Logic k, bool? v) {
    if (_entries.containsKey(k) && _entries[k] != null) {
      if (_entries[k] == v) {
        return false;
      } else {
        throw InconsistentAssumptions(this, k, v);
      }
    } else {
      _entries[k] = v;
      return true;
    }
  }

  // *********************************************
  // * This is the workhorse, so keep it *fast*. *
  // *********************************************
  /// Update the KB with all the implications of a list of facts.
  ///
  /// [facts] can be specified as a Map.
  void deduceAllFacts(Map<Logic, bool?> facts) {
    // Keep frequently used attributes locally, so we'll avoid extra
    // attribute access overhead
    final fullImplications = rules.fullImplications;
    final betaTriggers = rules.betaTriggers;
    final betaRules = rules.betaRules;

    final factsCopy = Map<Logic, bool?>.from(facts);
    while (factsCopy.isNotEmpty) {
      final betaMayTrigger = <int>{};

      // --- alpha chains ---
      for (final entry in factsCopy.entries) {
        final (k, v) = (entry.key, entry.value);
        if (!_tell(k, v) || v == null) {
          continue;
        }

        // lookup routing tables
        for (final (key, value) in fullImplications[(k, v)]) {
          _tell(key, value);
        }

        betaMayTrigger.addAll(betaTriggers[(k, v)]);
      }

      // --- beta chains ---
      factsCopy.clear();
      for (final bIdx in betaMayTrigger) {
        final (bcond, bimpl) = betaRules[bIdx];
        if (bcond.every(((Logic, bool) kv) => _entries[kv.$1] == kv.$2)) {
          factsCopy[bimpl.$1] = bimpl.$2;
        }
      }
    }
  }
}

/// Generate the default assumption rules
///
/// This method should only be called by bin/ask_update.dart
/// to update the pre-generated assumption rules.
FactRules generateFactRules() {
  return FactRules([
    'integer        ->  rational',
    'rational       ->  real',
    'rational       ->  algebraic',
    'algebraic      ->  complex',
    'transcendental ==  complex & !algebraic',
    'real           ->  hermitian',
    'imaginary      ->  complex',
    'imaginary      ->  antiHermitian',
    'extendedReal   ->  commutative',
    'complex        ->  commutative',
    'complex        ->  finite',
    'odd            ==  integer & !even',
    'even           ==  integer & !odd',
    'real           ->  complex',
    'extendedReal   ->  real | infinite',
    'real           ==  extendedReal & finite',
    'extendedReal        ==  extendedNegative | zero | extendedPositive',
    'extendedNegative    ==  extendedNonPositive & extendedNonzero',
    'extendedPositive    ==  extendedNonNegative & extendedNonzero',
    'extendedNonPositive ==  extendedReal & !extendedPositive',
    'extendedNonNegative ==  extendedReal & !extendedNegative',
    'real           ==  negative | zero | positive',
    'negative       ==  nonPositive & nonzero',
    'positive       ==  nonNegative & nonzero',
    'nonPositive    ==  real & !positive',
    'nonNegative    ==  real & !negative',
    'positive       ==  extendedPositive & finite',
    'negative       ==  extendedNegative & finite',
    'nonPositive    ==  extendedNonPositive & finite',
    'nonNegative    ==  extendedNonNegative & finite',
    'nonzero        ==  extendedNonzero & finite',
    'zero           ->  even & finite',
    'zero           ==  extendedNonNegative & extendedNonPositive',
    'zero           ==  nonNegative & nonPositive',
    'nonzero        ->  real',
    'prime          ->  integer & positive',
    'composite      ->  integer & positive & !prime',
    '!composite     ->  !positive | !even | prime',
    'irrational     ==  real & !rational',
    'imaginary      ->  !extendedReal',
    'infinite        ==  !finite',
    'nonInteger      ==  extendedReal & !integer',
    'extendedNonzero == extendedReal & !zero',
  ]);
}

extension LogicBoolSort on (Logic, bool) {
  static int sort((Logic, bool) a, (Logic, bool) b) {
    final ab1 = a.$1.compareTo(b.$1);
    if (ab1 != 0) {
      return ab1;
    }
    if (a.$2 == false && b.$2 == true) {
      return -1;
    } else if (a.$2 == true && b.$2 == false) {
      return 1;
    }
    return 0;
  }
}

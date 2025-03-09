import 'package:symbolic/utils/default_map.dart';
import 'package:test/test.dart' hide equals;
import '../utils/equals_matcher.dart' show equals;

import 'package:symbolic/core/facts.dart';
import 'package:symbolic/core/logic.dart';

void main() {
  final a = LogicAtom('a');
  final b = LogicAtom('b');
  final c = LogicAtom('c');
  final d = LogicAtom('d');
  final e = LogicAtom('e');
  final z = LogicAtom('z');
  final nz = LogicAtom('nz');

  final T = true;
  final F = false;
  final U = null;

  group("test deduce alpha implications", () {
    (DefaultMap<Logic, Set<Logic>>, DefaultMap<Logic, Set<Logic>>) D(
        List<(Logic, Logic)> i) {
      final I = deduceAlphaImplications(i);
      final rules = DefaultMap<(Logic, bool), Set<(Logic, bool)>>(
          () => <(Logic, bool)>{});
      for (final entry in I.entries) {
        final (k, S) = (entry.key, entry.value);
        rules[(k, true)] = {
          for (final v in S) (v, true),
        };
      }
      final P = rules2Prereq(rules);
      return (I, P);
    }

    final a = LogicAtom('a');
    final b = LogicAtom('b');
    final c = LogicAtom('c');
    final d = LogicAtom('d');
    final e = LogicAtom('e');

    test("transitivity", () {
      final (I, P) = D([(a, b), (b, c)]);
      expect(
          I,
          equals({
            a: {b, c},
            b: {c},
            Not.create(b): {Not.create(a)},
            Not.create(c): {Not.create(a), Not.create(b)}
          }));
      expect(
          P,
          equals({
            a: {b, c},
            b: {a, c},
            c: {a, b}
          }));
    });

    test("duplicate entry", () {
      final (I, P) = D([(a, b), (b, c), (b, c)]);
      expect(
          I,
          equals({
            a: {b, c},
            b: {c},
            Not.create(b): {Not.create(a)},
            Not.create(c): {Not.create(a), Not.create(b)}
          }));
      expect(
          P,
          equals({
            a: {b, c},
            b: {a, c},
            c: {a, b}
          }));
    });

    test("tolerant to cycles", () {
      final (I, P) = D([(a, a), (a, a)]);
      expect(I, equals({}));
      expect(P, equals({}));

      final (Q, T) = D([(a, b), (b, a)]);
      expect(
          Q,
          equals({
            a: {b},
            b: {a},
            Not.create(a): {Not.create(b)},
            Not.create(b): {Not.create(a)}
          }));
      expect(
          T,
          equals({
            a: {b},
            b: {a}
          }));
    });

    test("catch inconsistency", () {
      expect(() => D([(a, Not.create(a))]), throwsA(isA<ArgumentError>()));
      expect(
          () => D([(a, b), (b, Not.create(a))]), throwsA(isA<ArgumentError>()));
      expect(
          () => D([
                (a, b),
                (b, c),
                (b, LogicAtom('na')),
                (LogicAtom('na'), Not.create(a))
              ]),
          throwsA(isA<ArgumentError>()));
    });

    test("handle implications with negations", () {
      final (I, P) = D([(a, Not.create(b)), (c, b)]);
      expect(
          I,
          equals({
            a: {Not.create(b), Not.create(c)},
            b: {Not.create(a)},
            c: {b, Not.create(a)},
            Not.create(b): {Not.create(c)}
          }));
      expect(
          P,
          equals({
            a: {b, c},
            b: {a, c},
            c: {a, b}
          }));

      final (i2, p2) = D([(Not.create(a), b), (a, c)]);
      expect(
          i2,
          equals({
            a: {c},
            Not.create(a): {b},
            Not.create(b): {a, c},
            Not.create(c): {Not.create(a), b}
          }));
      expect(
          p2,
          equals({
            a: {b, c},
            b: {a, c},
            c: {a, b}
          }));
    });

    test("long deductions", () {
      final (I, P) = D([(a, b), (b, c), (c, d), (d, e)]);
      expect(
          I,
          equals({
            a: {b, c, d, e},
            b: {c, d, e},
            c: {d, e},
            d: {e},
            Not.create(b): {Not.create(a)},
            Not.create(c): {Not.create(a), Not.create(b)},
            Not.create(d): {Not.create(a), Not.create(b), Not.create(c)},
            Not.create(e): {
              Not.create(a),
              Not.create(b),
              Not.create(c),
              Not.create(d)
            }
          }));
      expect(
          P,
          equals({
            a: {b, c, d, e},
            b: {a, c, d, e},
            c: {a, b, d, e},
            d: {a, b, c, e},
            e: {a, b, c, d}
          }));
    });

    test("real-world", () {
      final (I, P) = D([
        (LogicAtom('rat'), LogicAtom('real')),
        (LogicAtom('int'), LogicAtom('rat'))
      ]);
      expect(
          I,
          equals({
            LogicAtom('int'): {LogicAtom('rat'), LogicAtom('real')},
            LogicAtom('rat'): {LogicAtom('real')},
            Not.create(LogicAtom('real')): {
              Not.create(LogicAtom('rat')),
              Not.create(LogicAtom('int'))
            },
            Not.create(LogicAtom('rat')): {Not.create(LogicAtom('int'))}
          }));
      expect(
          P,
          equals({
            LogicAtom('rat'): {LogicAtom('int'), LogicAtom('real')},
            LogicAtom('real'): {LogicAtom('int'), LogicAtom('rat')},
            LogicAtom('int'): {LogicAtom('rat'), LogicAtom('real')}
          }));
    });
  });

  group("test apply beta to alpha route", () {
    final apply = applyBetaToAlphaRoute;

    // indicates empty alpha-chain with attached beta-rule #bidx
    (Set<Logic>, List<int>) Q(int bidx) {
      return (<Logic>{}, [bidx]);
    }

    final a = LogicAtom('a');
    final b = LogicAtom('b');
    final c = LogicAtom('c');
    final d = LogicAtom('d');
    final e = LogicAtom('e');
    final p = LogicAtom('p');
    final x = LogicAtom('x');
    final y = LogicAtom('y');
    final z = LogicAtom('z');

    // x -> a        &(a,b) -> x     --  x -> a
    test("x -> a        &(a,b) -> x     --  x -> a", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a}
        });
      final B = [
        (And.fromList([a, b]), x)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a}, <int>[]),
            a: Q(0),
            b: Q(0)
          }));
    });

    // x -> a        &(a,!x) -> b    --  x -> a
    test("x -> a        &(a,!x) -> b    --  x -> a", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a}
        });
      final B = [
        (And.fromList([a, Not.create(x)]), b)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a}, <int>[]),
            Not.create(x): Q(0),
            a: Q(0)
          }));
    });

    // x -> a b      &(a,b) -> c     --  x -> a b c
    test("x -> a b      &(a,b) -> c     --  x -> a b c", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b}
        });
      final B = [
        (And.fromList([a, b]), c)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b, c}, <int>[]),
            a: Q(0),
            b: Q(0)
          }));
    });

    // x -> a        &(a,b) -> y     --  x -> a [#0]
    test("x -> a        &(a,b) -> y     --  x -> a [#0]", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a}
        });
      final B = [
        (And.fromList([a, b]), LogicAtom('y'))
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a}, [0]),
            a: Q(0),
            b: Q(0)
          }));
    });

    // x -> a b c    &(a,b) -> c     --  x -> a b c
    test("x -> a b c    &(a,b) -> c     --  x -> a b c", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b, c}
        });
      final B = [
        (And.fromList([a, b]), c)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b, c}, <int>[]),
            a: Q(0),
            b: Q(0)
          }));
    });

    // x -> a b      &(a,b,c) -> y   --  x -> a b [#0]
    test("x -> a b      &(a,b,c) -> y   --  x -> a b [#0]", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b}
        });
      final B = [
        (And.fromList([a, b, c]), LogicAtom('y'))
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b}, [0]),
            a: Q(0),
            b: Q(0),
            c: Q(0)
          }));
    });

    // x -> a b      &(a,b) -> c     --  x -> a b c d
    // c -> d                            c -> d
    test("x -> a b; c -> d      &(a,b) -> c     --  x -> a b c d; c -> d", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b},
          c: {d}
        });
      final B = [
        (And.fromList([a, b]), c)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b, c, d}, <int>[]),
            c: ({d}, <int>[]),
            a: Q(0),
            b: Q(0)
          }));
    });

    // x -> a b      &(a,b) -> c     --  x -> a b c d e
    // c -> d        &(c,d) -> e         c -> d e
    test(
        "x -> a b; c -> d      &(a,b) -> c; &(c,d) -> e     --  x -> a b c d e; c -> d e",
        () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b},
          c: {d}
        });
      final B = [
        (And.fromList([a, b]), c),
        (And.fromList([c, d]), e)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b, c, d, e}, <int>[]),
            c: ({d, e}, <int>[]),
            a: Q(0),
            b: Q(0),
            d: Q(1)
          }));
    });

    // x -> a b      &(a,y) -> z     --  x -> a b y z
    //               &(a,b) -> y
    test("x -> a b      &(a,y) -> z, &(a,b) -> y     --  x -> a b y z", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b}
        });
      final B = [
        (And.fromList([a, y]), z),
        (And.fromList([a, b]), y)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b, y, z}, <int>[]),
            a: (<Logic>{}, [0, 1]),
            y: Q(0),
            b: Q(1)
          }));
    });

    // x -> a b      &(a,!b) -> c    --  x -> a b
    test("x -> a b      &(a,!b) -> c    --  x -> a b", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b}
        });
      final B = [
        (And.fromList([a, Not.create(b)]), c)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b}, <int>[]),
            a: Q(0),
            Not.create(b): Q(0)
          }));
    });

    // !x -> !a !b   &(!a,b) -> c    --  !x -> !a !b
    test("!x -> !a !b   &(!a,b) -> c    --  !x -> !a !b", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          Not.create(x): {Not.create(a), Not.create(b)}
        });
      final B = [
        (And.fromList([Not.create(a), b]), c)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            Not.create(x): ({Not.create(a), Not.create(b)}, <int>[]),
            Not.create(a): Q(0),
            b: Q(0)
          }));
    });

    // x -> a b      &(b,c) -> !a    --  x -> a b
    test("x -> a b      &(b,c) -> !a    --  x -> a b", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b}
        });
      final B = [
        (And.fromList([b, c]), Not.create(a))
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b}, <int>[]),
            b: Q(0),
            c: Q(0)
          }));
    });

    // x -> a b      &(a, b) -> c    --  x -> a b c p
    // c -> p a
    test("x -> a b; c -> p a      &(a, b) -> c    --  x -> a b c p", () {
      final A = DefaultMap<Logic, Set<Logic>>(() => <Logic>{})
        ..addAll({
          x: {a, b},
          c: {p, a}
        });
      final B = [
        (And.fromList([a, b]), c)
      ];
      final result = apply(A, B);
      expect(
          result,
          equals({
            x: ({a, b, c, p}, <int>[]),
            c: ({p, a}, <int>[]),
            a: Q(0),
            b: Q(0)
          }));
    });
  });

  test("test FactRules parse", () {
    final f = FactRules(['a -> b']);
    expect(
        f.prereq,
        equals({
          b: {a},
          a: {b}
        }));

    final f2 = FactRules(['a -> !b']);
    expect(
        f2.prereq,
        equals({
          b: {a},
          a: {b}
        }));

    final f3 = FactRules(['!a -> b']);
    expect(
        f3.prereq,
        equals({
          b: {a},
          a: {b}
        }));

    final f4 = FactRules(['!a -> !b']);
    expect(
        f4.prereq,
        equals({
          b: {a},
          a: {b}
        }));

    final f5 = FactRules(['!z == nz']);
    expect(
        f5.prereq,
        equals({
          z: {nz},
          nz: {z}
        }));
  });

  test("test FactRules parse2", () {
    expect(() => FactRules(['a -> !a']), throwsA(isA<ArgumentError>()));
  });

  test("test FactRules deduce", () {
    final f = FactRules(['a -> b', 'b -> c', 'b -> d', 'c -> e']);

    Map<Logic, bool?> D(Map<Logic, bool?> facts) {
      final kb = FactKB(f);
      kb.deduceAllFacts(facts);
      return kb.toMap();
    }

    expect(D({a: T}), equals({a: T, b: T, c: T, d: T, e: T}));
    expect(D({b: T}), equals({b: T, c: T, d: T, e: T}));
    expect(D({c: T}), equals({c: T, e: T}));
    expect(D({d: T}), equals({d: T}));
    expect(D({e: T}), equals({e: T}));

    expect(D({a: F}), equals({a: F}));
    expect(D({b: F}), equals({a: F, b: F}));
    expect(D({c: F}), equals({a: F, b: F, c: F}));
    expect(D({d: F}), equals({a: F, b: F, d: F}));
    expect(D({e: F}), equals({a: F, b: F, c: F, e: F}));

    expect(D({a: U}), equals({a: U})); // XXX ok?
  });

  test("test FactRules deduce2", () {
    // pos/neg/zero, but the rules are not sufficient to derive all relations
    FactRules f = FactRules(['pos -> !neg', 'pos -> !z']);

    Map<Logic, bool?> D(Map<Logic, bool?> facts) {
      final kb = FactKB(f);
      kb.deduceAllFacts(facts);
      return kb.toMap();
    }

    expect(D({LogicAtom('pos'): T}),
        equals({LogicAtom('pos'): T, LogicAtom('neg'): F, LogicAtom('z'): F}));
    expect(D({LogicAtom('pos'): F}), equals({LogicAtom('pos'): F}));
    expect(D({LogicAtom('neg'): T}),
        equals({LogicAtom('pos'): F, LogicAtom('neg'): T}));
    expect(D({LogicAtom('neg'): F}), equals({LogicAtom('neg'): F}));
    expect(D({LogicAtom('z'): T}),
        equals({LogicAtom('pos'): F, LogicAtom('z'): T}));
    expect(D({LogicAtom('z'): F}), equals({LogicAtom('z'): F}));

    // pos/neg/zero. rules are sufficient to derive all relations
    f = FactRules(['pos -> !neg', 'neg -> !pos', 'pos -> !z', 'neg -> !z']);

    expect(D({LogicAtom('pos'): T}),
        equals({LogicAtom('pos'): T, LogicAtom('neg'): F, LogicAtom('z'): F}));
    expect(D({LogicAtom('pos'): F}), equals({LogicAtom('pos'): F}));
    expect(D({LogicAtom('neg'): T}),
        equals({LogicAtom('pos'): F, LogicAtom('neg'): T, LogicAtom('z'): F}));
    expect(D({LogicAtom('neg'): F}), equals({LogicAtom('neg'): F}));
    expect(D({LogicAtom('z'): T}),
        equals({LogicAtom('pos'): F, LogicAtom('neg'): F, LogicAtom('z'): T}));
    expect(D({LogicAtom('z'): F}), equals({LogicAtom('z'): F}));
  });

  test("test FactRules deduce multiple", () {
    // deduction that involves _several_ starting points
    final f = FactRules(['real == pos | npos']);

    Map<Logic, bool?> D(Map<Logic, bool?> facts) {
      final kb = FactKB(f);
      kb.deduceAllFacts(facts);
      return kb.toMap();
    }

    expect(D({LogicAtom('real'): T}), equals({LogicAtom('real'): T}));
    expect(
        D({LogicAtom('real'): F}),
        equals(
            {LogicAtom('real'): F, LogicAtom('pos'): F, LogicAtom('npos'): F}));
    expect(D({LogicAtom('pos'): T}),
        equals({LogicAtom('real'): T, LogicAtom('pos'): T}));
    expect(D({LogicAtom('npos'): T}),
        equals({LogicAtom('real'): T, LogicAtom('npos'): T}));

    // --- key tests below ---
    expect(
        D({LogicAtom('pos'): F, LogicAtom('npos'): F}),
        equals(
            {LogicAtom('real'): F, LogicAtom('pos'): F, LogicAtom('npos'): F}));
    expect(
        D({LogicAtom('real'): T, LogicAtom('pos'): F}),
        equals(
            {LogicAtom('real'): T, LogicAtom('pos'): F, LogicAtom('npos'): T}));
    expect(
        D({LogicAtom('real'): T, LogicAtom('npos'): F}),
        equals(
            {LogicAtom('real'): T, LogicAtom('pos'): T, LogicAtom('npos'): F}));

    expect(
        D({LogicAtom('pos'): T, LogicAtom('npos'): F}),
        equals(
            {LogicAtom('real'): T, LogicAtom('pos'): T, LogicAtom('npos'): F}));
    expect(
        D({LogicAtom('pos'): F, LogicAtom('npos'): T}),
        equals(
            {LogicAtom('real'): T, LogicAtom('pos'): F, LogicAtom('npos'): T}));
  });

  test("test FactRules deduce multiple2", () {
    final f = FactRules(['real == neg | zero | pos']);

    Map<Logic, bool?> D(Map<Logic, bool?> facts) {
      final kb = FactKB(f);
      kb.deduceAllFacts(facts);
      return kb.toMap();
    }

    expect(D({LogicAtom('real'): T}), equals({LogicAtom('real'): T}));
    expect(
        D({LogicAtom('real'): F}),
        equals({
          LogicAtom('real'): F,
          LogicAtom('neg'): F,
          LogicAtom('zero'): F,
          LogicAtom('pos'): F
        }));
    expect(D({LogicAtom('neg'): T}),
        equals({LogicAtom('real'): T, LogicAtom('neg'): T}));
    expect(D({LogicAtom('zero'): T}),
        equals({LogicAtom('real'): T, LogicAtom('zero'): T}));
    expect(D({LogicAtom('pos'): T}),
        equals({LogicAtom('real'): T, LogicAtom('pos'): T}));

    // --- key tests below ---
    expect(
        D({LogicAtom('neg'): F, LogicAtom('zero'): F, LogicAtom('pos'): F}),
        equals({
          LogicAtom('real'): F,
          LogicAtom('neg'): F,
          LogicAtom('zero'): F,
          LogicAtom('pos'): F
        }));
    expect(D({LogicAtom('real'): T, LogicAtom('neg'): F}),
        equals({LogicAtom('real'): T, LogicAtom('neg'): F}));
    expect(D({LogicAtom('real'): T, LogicAtom('zero'): F}),
        equals({LogicAtom('real'): T, LogicAtom('zero'): F}));
    expect(D({LogicAtom('real'): T, LogicAtom('pos'): F}),
        equals({LogicAtom('real'): T, LogicAtom('pos'): F}));

    expect(
        D({LogicAtom('real'): T, LogicAtom('zero'): F, LogicAtom('pos'): F}),
        equals({
          LogicAtom('real'): T,
          LogicAtom('neg'): T,
          LogicAtom('zero'): F,
          LogicAtom('pos'): F
        }));
    expect(
        D({LogicAtom('real'): T, LogicAtom('neg'): F, LogicAtom('pos'): F}),
        equals({
          LogicAtom('real'): T,
          LogicAtom('neg'): F,
          LogicAtom('zero'): T,
          LogicAtom('pos'): F
        }));
    expect(
        D({LogicAtom('real'): T, LogicAtom('neg'): F, LogicAtom('zero'): F}),
        equals({
          LogicAtom('real'): T,
          LogicAtom('neg'): F,
          LogicAtom('zero'): F,
          LogicAtom('pos'): T
        }));
    expect(
        D({LogicAtom('neg'): T, LogicAtom('zero'): F, LogicAtom('pos'): F}),
        equals({
          LogicAtom('real'): T,
          LogicAtom('neg'): T,
          LogicAtom('zero'): F,
          LogicAtom('pos'): F
        }));
    expect(
        D({LogicAtom('neg'): F, LogicAtom('zero'): T, LogicAtom('pos'): F}),
        equals({
          LogicAtom('real'): T,
          LogicAtom('neg'): F,
          LogicAtom('zero'): T,
          LogicAtom('pos'): F
        }));
    expect(
        D({LogicAtom('neg'): F, LogicAtom('zero'): F, LogicAtom('pos'): T}),
        equals({
          LogicAtom('real'): T,
          LogicAtom('neg'): F,
          LogicAtom('zero'): F,
          LogicAtom('pos'): T
        }));
  });

  test("test FactRules deduce base", () {
    // deduction that starts from base

    final f = FactRules([
      'real  == neg | zero | pos',
      'neg   -> real & !zero & !pos',
      'pos   -> real & !zero & !neg'
    ]);
    final base = FactKB(f);

    base.deduceAllFacts({LogicAtom('real'): T, LogicAtom('neg'): F});
    expect(base.toMap(), equals({LogicAtom('real'): T, LogicAtom('neg'): F}));

    base.deduceAllFacts({LogicAtom('zero'): F});
    expect(
        base.toMap(),
        equals({
          LogicAtom('real'): T,
          LogicAtom('neg'): F,
          LogicAtom('zero'): F,
          LogicAtom('pos'): T
        }));
  });

  test("test FactRules deduce staticext", () {
    // verify that static beta-extensions deduction takes place
    final f = FactRules([
      'real  == neg | zero | pos',
      'neg   -> real & !zero & !pos',
      'pos   -> real & !zero & !neg',
      'nneg  == real & !neg',
      'npos  == real & !pos',
    ]);

    expect(f.fullImplications[(LogicAtom('neg'), true)],
        contains((LogicAtom('npos'), true)));
    expect(f.fullImplications[(LogicAtom('pos'), true)],
        contains((LogicAtom('nneg'), true)));
    expect(f.fullImplications[(LogicAtom('zero'), true)],
        contains((LogicAtom('nneg'), true)));
    expect(f.fullImplications[(LogicAtom('zero'), true)],
        contains((LogicAtom('npos'), true)));
  });
}

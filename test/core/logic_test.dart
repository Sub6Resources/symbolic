import 'package:test/test.dart';

import 'package:symbolic/core/logic.dart';

void main() {
  final a = LogicAtom('a');
  final b = LogicAtom('b');
  final c = LogicAtom('c');
  final d = LogicAtom('d');
  final n = LogicAtom('n');
  final p = LogicAtom('p');
  final r = LogicAtom('r');
  final t = LogicAtom('t');

  test("test logic cmp", () {
    final l1 = And.fromList([a, Not.create(b)]);
    final l2 = And.fromList([a, Not.create(b)]);
    expect(l1.hashCode, equals(l2.hashCode));
    expect((l1 == l2), isTrue);
    expect((l1 != l2), isFalse);

    expect(And.fromList([a, b, c]), equals(And.fromList([b, a, c])));
    expect(And.fromList([a, b, c]), equals(And.fromList([c, b, a])));
    expect(And.fromList([a, b, c]), equals(And.fromList([c, a, b])));

    expect(Not.create(a) < Not.create(b), isTrue);
    expect((Not.create(b) < Not.create(a)), isFalse);
  });

  test('test logic onearg', () {
    expect(And.fromList([]), isA<True>());
    expect(Or.fromList([]), isA<False>());

    expect(And.fromList([True()]), equals(True()));
    expect(And.fromList([False()]), equals(False()));
    expect(Or.fromList([True()]), equals(True()));
    expect(Or.fromList([False()]), equals(False()));

    expect(And.fromList([a]), equals(a));
    expect(Or.fromList([a]), equals(a));
  });

  test('test logic xnotx', () {
    expect(And.fromList([a, Not.create(a)]), isA<False>());
    expect(Or.fromList([a, Not.create(a)]), isA<True>());
  });

  test('test logic eval TF', () {
    expect(And.fromList([False(), False()]), isA<False>());
    expect(And.fromList([False(), True()]), isA<False>());
    expect(And.fromList([True(), False()]), isA<False>());
    expect(And.fromList([True(), True()]), isA<True>());

    expect(Or.fromList([False(), False()]), isA<False>());
    expect(Or.fromList([False(), True()]), isA<True>());
    expect(Or.fromList([True(), False()]), isA<True>());
    expect(Or.fromList([True(), True()]), isA<True>());

    expect(And.fromList([a, True()]), equals(a));
    expect(And.fromList([a, False()]), isA<False>());
    expect(Or.fromList([a, True()]), equals(True()));
    expect(Or.fromList([a, False()]), equals(a));
  });

  test('test logic combine args', () {
    expect(And.fromList([a, b, a]), equals(And.fromList([a, b])));
    expect(Or.fromList([a, b, a]), equals(Or.fromList([a, b])));

    expect(
        And.fromList([
          And.fromList([a, b]),
          And.fromList([c, d])
        ]),
        equals(And.fromList([a, b, c, d])));
    expect(
        Or.fromList([
          Or.fromList([a, b]),
          Or.fromList([c, d])
        ]),
        equals(Or.fromList([a, b, c, d])));

    expect(
      Or.fromList([
        t,
        And.fromList([n, p, r]),
        And.fromList([n, r]),
        And.fromList([n, p, r]),
        t,
        And.fromList([n, r]),
      ]),
      equals(Or.fromList([
        t,
        And.fromList([n, p, r]),
        And.fromList([n, r]),
      ])),
    );
  });

  test('test logic expand', () {
    final t = And.fromList([
      Or.fromList([a, b]),
      c
    ]);
    expect(
        t.expand(),
        equals(Or.fromList([
          And.fromList([a, c]),
          And.fromList([b, c])
        ])));

    final t2 = And.fromList([
      Or.fromList([a, Not.create(b)]),
      b
    ]);
    expect(t2.expand(), equals(And.fromList([a, b])));

    final t3 = And.fromList([
      Or.fromList([a, b]),
      Or.fromList([c, d])
    ]);
    expect(
        t3.expand(),
        equals(Or.fromList([
          And.fromList([a, c]),
          And.fromList([a, d]),
          And.fromList([b, c]),
          And.fromList([b, d]),
        ])));
  });

  test('test logic fromstring', () {
    final S = Logic.fromString;

    expect(S('a'), equals(a));
    expect(S('!a'), equals(Not.create(a)));
    expect(S('a & b'), equals(And.fromList([a, b])));
    expect(S('a | b'), equals(Or.fromList([a, b])));
    expect(
        S('a | b & c'),
        equals(And.fromList([
          Or.fromList([a, b]),
          c
        ])));
    expect(
        S('a & b | c'),
        equals(Or.fromList([
          And.fromList([a, b]),
          c
        ])));
    expect(S('a & b & c'), equals(And.fromList([a, b, c])));
    expect(S('a | b | c'), equals(Or.fromList([a, b, c])));

    expect(() => S('| a'), throwsA(isA<FormatException>()));
    expect(() => S('& a'), throwsA(isA<FormatException>()));
    expect(() => S('a | | b'), throwsA(isA<FormatException>()));
    expect(() => S('a | & b'), throwsA(isA<FormatException>()));
    expect(() => S('a & & b'), throwsA(isA<FormatException>()));
    expect(() => S('a |'), throwsA(isA<FormatException>()));
    expect(() => S('a|b'), throwsA(isA<FormatException>()));
    expect(() => S('!'), throwsA(isA<FormatException>()));
    expect(() => S('! a'), throwsA(isA<FormatException>()));
    expect(() => S('!(a + 1)'), throwsA(isA<FormatException>()));
    expect(() => S(''), throwsA(isA<FormatException>()));
  });

  test('test logic not', () {
    expect(Not.create(Not.create(a)), equals(a));
    expect(Not.create(True()), equals(False()));
    expect(Not.create(False()), equals(True()));

    // NOTE: we may want to change default Not behaviour and put this
    // functionality into some method.
    expect(Not.create(And.fromList([a, b])),
        equals(Or.fromList([Not.create(a), Not.create(b)])));
    expect(Not.create(Or.fromList([a, b])),
        equals(And.fromList([Not.create(a), Not.create(b)])));
  });

  test('test formatting', () {
    final S = Logic.fromString;

    expect(() => S('a&b'), throwsA(isA<FormatException>()));
    expect(() => S('a|b'), throwsA(isA<FormatException>()));
    expect(() => S('! a'), throwsA(isA<FormatException>()));
  });
}

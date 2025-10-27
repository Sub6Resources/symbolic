import 'package:symbolic/core/facts.dart';
import 'package:symbolic/core/logic.dart';
import 'package:symbolic/core/assumptions_generated.dart' show factRules;

/// All symbolic objects have assumption attributes that can be accessed via
/// `.is<AssumptionName>` attribute.
///
/// Assumptions determine certain properties of symbolic objects and can
/// have 3 possible values: `true`, `false`, `null`.  `true` is returned if the
/// object has the property and `false` is returned if it does not or cannot
/// (i.e. does not make sense).
///
/// When the property cannot be determined (or when a method is not
/// implemented) `null` will be returned. For example, a generic symbol, `x`,
/// may or may not be positive so a value of `null` is returned for `x.isPositive`.
///
/// By default, all symbolic values are in the largest set in the given context
/// without specifying the property. For example, a symbol that has a property
/// being integer, is also real, complex, etc.
class Assumptions {
  /// object commutes with any other object with
  /// respect to multiplication operation.
  ///
  /// See https://en.wikipedia.org/wiki/Commutative_property.
  final bool? commutative;

  /// object can have only values from the set
  /// of complex numbers.
  ///
  /// See https://en.wikipedia.org/wiki/Complex_number.
  final bool? complex;

  /// object value is a number that can be written as a real
  /// number multiplied by the imaginary unit `I`.
  ///
  /// See https://en.wikipedia.org/wiki/Imaginary_number.
  ///
  /// Please note that `0` is not considered to be an imaginary number.
  final bool? imaginary;

  /// object can only have values from the set
  /// of real numbers.
  final bool? real;

  /// object can only have values from the set
  /// of real numbers, `oo`, and `-oo`.
  final bool? extendedReal;

  /// object can only have values from the set
  /// of integers.
  final bool? integer;

  /// object can only have values from the set
  /// of real numbers excluding the set of integers.
  final bool? nonInteger;

  /// object can only have values from the set of
  /// odd integers.
  ///
  /// See https://en.wikipedia.org/wiki/Parity_%28mathematics%29
  final bool? odd;

  /// object can only have values from the set of
  /// even integers.
  ///
  /// See https://en.wikipedia.org/wiki/Parity_%28mathematics%29
  final bool? even;

  /// object is a natural number greater than 1 that has
  /// no positive divisors other than 1 and itself.
  ///
  /// See https://en.wikipedia.org/wiki/Prime_number
  final bool? prime;

  /// object is a positive integer that has at least one positive
  /// divisor other than 1 or the number itself.
  ///
  /// See https://en.wikipedia.org/wiki/Composite_number
  final bool? composite;

  /// object has the value of 0.
  final bool? zero;

  /// object is a real number that is not zero.
  final bool? nonzero;

  /// object can only have values from the set
  /// of rationals.
  final bool? rational;

  /// object can only have values from the set
  /// of algebraic numbers.
  ///
  /// See https://en.wikipedia.org/wiki/Algebraic_number.
  final bool? algebraic;

  /// object can only have values from the set
  /// of transcendental numbers.
  ///
  /// See https://en.wikipedia.org/wiki/Transcendental_number
  final bool? transcendental;

  /// object value cannot be represented exactly as a
  /// rational number.
  ///
  /// See https://en.wikipedia.org/wiki/Irrational_number
  final bool? irrational;

  /// Object absolute value is bounded.
  ///
  /// See https://en.wikipedia.org/wiki/Finite
  final bool? finite;

  /// Object absolute value is arbitrarily large.
  ///
  /// See https://en.wikipedia.org/wiki/Infinite
  final bool? infinite;

  /// object can have only negative values.
  ///
  /// See https://en.wikipedia.org/wiki/Negative_number
  final bool? negative;

  /// object can have only non-negative values.
  ///
  /// See https://en.wikipedia.org/wiki/nonnegative
  final bool? nonNegative;

  /// object can have only positive values.
  final bool? positive;

  /// object can have only non-positive values.
  ///
  /// See https://en.wikipedia.org/wiki/nonpositive
  final bool? nonPositive;

  /// As [negative], but also including `-oo`.
  final bool? extendedNegative;

  /// As [nonNegative], but also including `oo`.
  final bool? extendedNonNegative;

  /// As [positive], but also including `oo`.
  final bool? extendedPositive;

  /// As [nonPositive], but also including `-oo`.
  final bool? extendedNonPositive;

  /// As [nonzero], but also including `oo` and `-oo`.
  final bool? extendedNonzero;

  /// object belongs to the field of Hermitian operators.
  ///
  /// See https://en.wikipedia.org/wiki/Hermitian_operator
  final bool? hermitian;

  /// object belongs to the field of anti-Hermitian operators.
  ///
  /// See https://en.wikipedia.org/wiki/Skew-Hermitian_matrix
  final bool? antiHermitian;

  /// Creates a new Assumptions object with the specified assumptions.
  const Assumptions({
    this.commutative,
    this.complex,
    this.imaginary,
    this.real,
    this.extendedReal,
    this.integer,
    this.nonInteger,
    this.odd,
    this.even,
    this.prime,
    this.composite,
    this.zero,
    this.nonzero,
    this.rational,
    this.algebraic,
    this.transcendental,
    this.irrational,
    this.finite,
    this.infinite,
    this.negative,
    this.nonNegative,
    this.positive,
    this.nonPositive,
    this.extendedNegative,
    this.extendedNonNegative,
    this.extendedPositive,
    this.extendedNonPositive,
    this.extendedNonzero,
    this.hermitian,
    this.antiHermitian,
  });

  /// This helper constructor ensures at compile-time
  /// that every attribute has been specified.
  const Assumptions._full({
    required this.commutative,
    required this.complex,
    required this.imaginary,
    required this.real,
    required this.extendedReal,
    required this.integer,
    required this.nonInteger,
    required this.odd,
    required this.even,
    required this.prime,
    required this.composite,
    required this.zero,
    required this.nonzero,
    required this.rational,
    required this.algebraic,
    required this.transcendental,
    required this.irrational,
    required this.finite,
    required this.infinite,
    required this.negative,
    required this.nonNegative,
    required this.positive,
    required this.nonPositive,
    required this.extendedNegative,
    required this.extendedNonNegative,
    required this.extendedPositive,
    required this.extendedNonPositive,
    required this.extendedNonzero,
    required this.hermitian,
    required this.antiHermitian,
  });

  @override
  int get hashCode =>
      commutative.hashCode ^
      complex.hashCode ^
      imaginary.hashCode ^
      real.hashCode ^
      extendedReal.hashCode ^
      integer.hashCode ^
      nonInteger.hashCode ^
      odd.hashCode ^
      even.hashCode ^
      prime.hashCode ^
      composite.hashCode ^
      zero.hashCode ^
      nonzero.hashCode ^
      rational.hashCode ^
      algebraic.hashCode ^
      transcendental.hashCode ^
      irrational.hashCode ^
      finite.hashCode ^
      infinite.hashCode ^
      negative.hashCode ^
      nonNegative.hashCode ^
      positive.hashCode ^
      nonPositive.hashCode ^
      extendedNegative.hashCode ^
      extendedNonNegative.hashCode ^
      extendedPositive.hashCode ^
      extendedNonPositive.hashCode ^
      extendedNonzero.hashCode ^
      hermitian.hashCode ^
      antiHermitian.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Assumptions) {
      return commutative == other.commutative &&
          complex == other.complex &&
          imaginary == other.imaginary &&
          real == other.real &&
          extendedReal == other.extendedReal &&
          integer == other.integer &&
          nonInteger == other.nonInteger &&
          odd == other.odd &&
          even == other.even &&
          prime == other.prime &&
          composite == other.composite &&
          zero == other.zero &&
          nonzero == other.nonzero &&
          rational == other.rational &&
          algebraic == other.algebraic &&
          transcendental == other.transcendental &&
          irrational == other.irrational &&
          finite == other.finite &&
          infinite == other.infinite &&
          negative == other.negative &&
          nonNegative == other.nonNegative &&
          positive == other.positive &&
          nonPositive == other.nonPositive &&
          extendedNegative == other.extendedNegative &&
          extendedNonNegative == other.extendedNonNegative &&
          extendedPositive == other.extendedPositive &&
          extendedNonPositive == other.extendedNonPositive &&
          extendedNonzero == other.extendedNonzero &&
          hermitian == other.hermitian &&
          antiHermitian == other.antiHermitian;
    }
    return false;
  }

  /// Creates a copy of these assumptions.
  Assumptions copy() {
    return Assumptions._full(
      commutative: commutative,
      complex: complex,
      imaginary: imaginary,
      real: real,
      extendedReal: extendedReal,
      integer: integer,
      nonInteger: nonInteger,
      odd: odd,
      even: even,
      prime: prime,
      composite: composite,
      zero: zero,
      nonzero: nonzero,
      rational: rational,
      algebraic: algebraic,
      transcendental: transcendental,
      irrational: irrational,
      finite: finite,
      infinite: infinite,
      negative: negative,
      nonNegative: nonNegative,
      positive: positive,
      nonPositive: nonPositive,
      extendedNegative: extendedNegative,
      extendedNonNegative: extendedNonNegative,
      extendedPositive: extendedPositive,
      extendedNonPositive: extendedNonPositive,
      extendedNonzero: extendedNonzero,
      hermitian: hermitian,
      antiHermitian: antiHermitian,
    );
  }

  /// Creates a copy of these assumptions with the specified items replaced.
  ///
  /// null values passed to this method will not replace existing true/false
  /// values. Create a new `Assumptions` object to remove an assumption.
  Assumptions copyWith({
    bool? commutative,
    bool? complex,
    bool? imaginary,
    bool? real,
    bool? extendedReal,
    bool? integer,
    bool? nonInteger,
    bool? odd,
    bool? even,
    bool? prime,
    bool? composite,
    bool? zero,
    bool? nonzero,
    bool? rational,
    bool? algebraic,
    bool? transcendental,
    bool? irrational,
    bool? finite,
    bool? infinite,
    bool? negative,
    bool? nonNegative,
    bool? positive,
    bool? nonPositive,
    bool? extendedNegative,
    bool? extendedNonNegative,
    bool? extendedPositive,
    bool? extendedNonPositive,
    bool? extendedNonzero,
    bool? hermitian,
    bool? antiHermitian,
  }) {
    return Assumptions._full(
      commutative: commutative ?? this.commutative,
      complex: complex ?? this.complex,
      imaginary: imaginary ?? this.imaginary,
      real: real ?? this.real,
      extendedReal: extendedReal ?? this.extendedReal,
      integer: integer ?? this.integer,
      nonInteger: nonInteger ?? this.nonInteger,
      odd: odd ?? this.odd,
      even: even ?? this.even,
      prime: prime ?? this.prime,
      composite: composite ?? this.composite,
      zero: zero ?? this.zero,
      nonzero: nonzero ?? this.nonzero,
      rational: rational ?? this.rational,
      algebraic: algebraic ?? this.algebraic,
      transcendental: transcendental ?? this.transcendental,
      irrational: irrational ?? this.irrational,
      finite: finite ?? this.finite,
      infinite: infinite ?? this.infinite,
      negative: negative ?? this.negative,
      nonNegative: nonNegative ?? this.nonNegative,
      positive: positive ?? this.positive,
      nonPositive: nonPositive ?? this.nonPositive,
      extendedNegative: extendedNegative ?? this.extendedNegative,
      extendedNonNegative: extendedNonNegative ?? this.extendedNonNegative,
      extendedPositive: extendedPositive ?? this.extendedPositive,
      extendedNonPositive: extendedNonPositive ?? this.extendedNonPositive,
      extendedNonzero: extendedNonzero ?? this.extendedNonzero,
      hermitian: hermitian ?? this.hermitian,
      antiHermitian: antiHermitian ?? this.antiHermitian,
    );
  }

  /// Used internally in symbolic's logic system to deduce all possible
  /// assumptions from the original assumptions.
  Map<Logic, bool?> toLogicMap() {
    return {
      LogicAtom("commutative"): commutative,
      LogicAtom("complex"): complex,
      LogicAtom("imaginary"): imaginary,
      LogicAtom("real"): real,
      LogicAtom("extendedReal"): extendedReal,
      LogicAtom("integer"): integer,
      LogicAtom("nonInteger"): nonInteger,
      LogicAtom("odd"): odd,
      LogicAtom("even"): even,
      LogicAtom("prime"): prime,
      LogicAtom("composite"): composite,
      LogicAtom("zero"): zero,
      LogicAtom("nonzero"): nonzero,
      LogicAtom("rational"): rational,
      LogicAtom("algebraic"): algebraic,
      LogicAtom("transcendental"): transcendental,
      LogicAtom("irrational"): irrational,
      LogicAtom("finite"): finite,
      LogicAtom("infinite"): infinite,
      LogicAtom("negative"): negative,
      LogicAtom("nonNegative"): nonNegative,
      LogicAtom("positive"): positive,
      LogicAtom("nonPositive"): nonPositive,
      LogicAtom("extendedNegative"): extendedNegative,
      LogicAtom("extendedNonNegative"): extendedNonNegative,
      LogicAtom("extendedPositive"): extendedPositive,
      LogicAtom("extendedNonPositive"): extendedNonPositive,
      LogicAtom("extendedNonzero"): extendedNonzero,
      LogicAtom("hermitian"): hermitian,
      LogicAtom("antiHermitian"): antiHermitian,
    };
  }

  /// Creates a new set of assumptions with the [parentAssumptions] filled
  /// in wherever there are null values in the existing assumptions.
  Assumptions inherit(Assumptions parentAssumptions) {
    return Assumptions._full(
      commutative: commutative ?? parentAssumptions.commutative,
      complex: complex ?? parentAssumptions.complex,
      imaginary: imaginary ?? parentAssumptions.imaginary,
      real: real ?? parentAssumptions.real,
      extendedReal: extendedReal ?? parentAssumptions.extendedReal,
      integer: integer ?? parentAssumptions.integer,
      nonInteger: nonInteger ?? parentAssumptions.nonInteger,
      odd: odd ?? parentAssumptions.odd,
      even: even ?? parentAssumptions.even,
      prime: prime ?? parentAssumptions.prime,
      composite: composite ?? parentAssumptions.composite,
      zero: zero ?? parentAssumptions.zero,
      nonzero: nonzero ?? parentAssumptions.nonzero,
      rational: rational ?? parentAssumptions.rational,
      algebraic: algebraic ?? parentAssumptions.algebraic,
      transcendental: transcendental ?? parentAssumptions.transcendental,
      irrational: irrational ?? parentAssumptions.irrational,
      finite: finite ?? parentAssumptions.finite,
      infinite: infinite ?? parentAssumptions.infinite,
      negative: negative ?? parentAssumptions.negative,
      nonNegative: nonNegative ?? parentAssumptions.nonNegative,
      positive: positive ?? parentAssumptions.positive,
      nonPositive: nonPositive ?? parentAssumptions.nonPositive,
      extendedNegative: extendedNegative ?? parentAssumptions.extendedNegative,
      extendedNonNegative: extendedNonNegative ?? parentAssumptions.extendedNonNegative,
      extendedPositive:  extendedPositive ?? parentAssumptions.extendedPositive,
      extendedNonPositive: extendedNonPositive ?? parentAssumptions.extendedNonPositive,
      extendedNonzero: extendedNonzero ?? parentAssumptions.extendedNonzero,
      hermitian: hermitian ?? parentAssumptions.hermitian,
      antiHermitian: antiHermitian ?? parentAssumptions.antiHermitian,
    );
  }

  /// A new Assumption object is created with a copy of the existing
  /// assumptions except that any assumptions that are set  to `true` in
  /// [assumptions] are now set to `null`
  ///
  /// For example, `Integer` is a `Rational`, but a `Rational` is assumed
  /// to not be `prime`, whereas an `Integer` could be `prime`.
  /// TODO use better example
  Assumptions remove(Assumptions assumptions) {
    return Assumptions._full(
      commutative: assumptions.commutative == true? null: commutative,
      complex: assumptions.complex == true? null: complex,
      imaginary: assumptions.imaginary == true? null: imaginary,
      real: assumptions.real == true? null: real,
      extendedReal: assumptions.extendedReal == true? null: extendedReal,
      integer: assumptions.integer == true? null: integer,
      nonInteger: assumptions.nonInteger == true? null: nonInteger,
      odd: assumptions.odd == true? null: odd,
      even: assumptions.even == true? null: even,
      prime: assumptions.prime == true? null: prime,
      composite: assumptions.composite == true? null: composite,
      zero: assumptions.zero == true? null: zero,
      nonzero: assumptions.nonzero == true? null: nonzero,
      rational: assumptions.rational == true? null: rational,
      algebraic: assumptions.algebraic == true? null: algebraic,
      transcendental: assumptions.transcendental == true? null: transcendental,
      irrational: assumptions.irrational == true? null: irrational,
      finite: assumptions.finite == true? null: finite,
      infinite: assumptions.infinite == true? null: infinite,
      negative: assumptions.negative == true? null: negative,
      nonNegative: assumptions.nonNegative == true? null: nonNegative,
      positive: assumptions.positive == true? null: positive,
      nonPositive: assumptions.nonPositive == true? null: nonPositive,
      extendedNegative: assumptions.extendedNegative == true? null: extendedNegative,
      extendedNonNegative: assumptions.extendedNonNegative == true? null: extendedNonNegative,
      extendedPositive: assumptions.extendedPositive == true? null: extendedPositive,
      extendedNonPositive: assumptions.extendedNonPositive == true? null: extendedNonPositive,
      extendedNonzero: assumptions.extendedNonzero == true? null: extendedNonzero,
      hermitian: assumptions.hermitian == true? null: hermitian,
      antiHermitian: assumptions.antiHermitian == true? null: antiHermitian,
    );
  }
}

/// A FactKB specialized for the built-in rules
///
/// This is the only kind of FactKB that Basic objects should use.
class StdFactKB extends FactKB {
  // late final Assumptions _generator;

  StdFactKB([Assumptions? facts]) : super(_assumeRules) {
    if (facts == null) {
      // _generator = Assumptions();
    } else {
      // _generator = facts;
      deduceAllFacts(facts.toLogicMap());
    }
  }

  /// Returns the derived assumptions after all facts have
  /// been deduced.
  Assumptions toAssumptions() {
    return Assumptions._full(
      commutative: this[LogicAtom("commutative")],
      complex: this[LogicAtom("complex")],
      imaginary: this[LogicAtom("imaginary")],
      real: this[LogicAtom("real")],
      extendedReal: this[LogicAtom("extendedReal")],
      integer: this[LogicAtom("integer")],
      nonInteger: this[LogicAtom("nonInteger")],
      odd: this[LogicAtom("odd")],
      even: this[LogicAtom("even")],
      prime: this[LogicAtom("prime")],
      composite: this[LogicAtom("composite")],
      zero: this[LogicAtom("zero")],
      nonzero: this[LogicAtom("nonzero")],
      rational: this[LogicAtom("rational")],
      algebraic: this[LogicAtom("algebraic")],
      transcendental: this[LogicAtom("transcendental")],
      irrational: this[LogicAtom("irrational")],
      finite: this[LogicAtom("finite")],
      infinite: this[LogicAtom("infinite")],
      negative: this[LogicAtom("negative")],
      nonNegative: this[LogicAtom("nonNegative")],
      positive: this[LogicAtom("positive")],
      nonPositive: this[LogicAtom("nonPositive")],
      extendedNegative: this[LogicAtom("extendedNegative")],
      extendedNonNegative: this[LogicAtom("extendedNonNegative")],
      extendedPositive: this[LogicAtom("extendedPositive")],
      extendedNonPositive: this[LogicAtom("extendedNonPositive")],
      extendedNonzero: this[LogicAtom("extendedNonzero")],
      hermitian: this[LogicAtom("hermitian")],
      antiHermitian: this[LogicAtom("antiHermitian")],
    );
  }
}

FactRules _loadPregeneratedAssumptionRules() {
  return factRules;
}

final _assumeRules = _loadPregeneratedAssumptionRules();

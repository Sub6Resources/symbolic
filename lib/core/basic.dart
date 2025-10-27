import 'dart:collection';

import 'package:symbolic/core/assumptions.dart';
import 'package:symbolic/core/numbers.dart';
import 'package:symbolic/core/sorting.dart';
import 'package:symbolic/core/symbol.dart';
import 'package:symbolic/core/traversal.dart';
import 'package:symbolic/simplify/simplify.dart' as s;
import 'package:symbolic/utilities/iterables.dart';

abstract class Basic<T extends Basic<T>> with DefaultAssumptions {
  Basic(this.args);

  final List<Basic<dynamic>> args;

  // To be overridden with true in the appropriate subclasses
  final bool isnumber = false; // TODO why two?
  final bool isAtom = false;
  final bool isSymbol = false;
  final bool issymbol = false; // TODO why two?
  final bool isIndexed = false;
  final bool isDummy = false;
  final bool isWild = false;
  final bool isFunction = false;
  final bool isAdd = false;
  final bool isMul = false;
  final bool isPow = false;
  final bool isNumber = false;
  final bool isFloat = false;
  final bool isRational = false;
  final bool isInteger = false;
  final bool isNumberSymbol = false;
  final bool isOrder = false;
  final bool isDerivative = false;
  final bool isPiecewise = false;
  final bool isPoly = false;
  final bool isAlgebraicNumber = false;
  final bool isRelational = false;
  final bool isEquality = false;
  final bool isBoolean = false;
  final bool isNot = false;
  final bool isMatrix = false;
  final bool isVector = false;
  final bool isPoint = false;
  final bool isMatAdd = false;
  final bool isMatMul = false;

  /// The same as [args]. Derived classes which do not fix an
  /// order on their arguments should override this method to
  /// produce the sorted representation.
  List<Basic<dynamic>> get _sortedArgs => args;

  /// Top-level function in an expression.
  ///
  /// For all objects, `x == x.func(x.args)` should hold.
  T func(List<Basic<dynamic>> args);

  (int, int, String) classKey() {
    return (5, 0, runtimeType.toString());
  }

  SortKey sortKey({String? order}) {
    final args = _sortedArgs;
    return SortKey(
      classKey: classKey(),
      argsLength: args.length,
      args: args.map((e) => e.sortKey(order: order)).toList(),
      exponentKey: One.instance.sortKey(),
      coefficient: One.instance,
    );
  }

  Set<Basic<dynamic>> freeSymbols() {
    return args.fold(<Basic<dynamic>>{}, (Set<Basic<dynamic>> acc, Basic<dynamic> arg) {
      acc.addAll(arg.freeSymbols());
      return acc;
    });
  }

  (Basic<dynamic>, Basic<dynamic>) asContentPrimitive({bool radical = false, bool clear = true}) {
    return (One.instance, this);
  }

  Basic<T> subs(Map<Basic<dynamic>, Basic<dynamic>> substitutions, [bool simultaneous = false]) {
    List<(Basic<dynamic>, Basic<dynamic>)> sequence = [];
    substitutions.forEach((key, value) {
      if(!isSame(key, value)) {
        sequence.add((key, value));
      }
    });

    final unordered = true; // The full version of subs allows ordered substitution.
    if(unordered) {
      LinkedHashMap<Basic<dynamic>, Basic<dynamic>> sequenceDict = LinkedHashMap();
      for(final (key, value) in sequence) {
        sequenceDict[key] = value;
      }
      // order so more complex items are first and items
      // of identical complexity are ordered so
      // f(x) < f(y) < x < y
      // \___ 2 __/    \_1_/  <- number of nodes
      //
      // For more complex ordering use an unordered sequence.
      final k = ordered(sequenceDict.keys, [(e) => -nodes(e), defaultSortKey]).toList();
      sequence = k.map((e) => (e, sequenceDict[e]!)).toList();

      // do infinities/NaNs first
      if(!simultaneous) {
        final redo = [];
        for (int i = 0; i < sequence.length; i++) {
          if(illegalNumbers.contains(sequence[i].$2)) {
            redo.insert(0, sequence[i]);
          }
        }
        for(final i in redo) {
          sequence.insert(0, sequence.removeAt(i));
        }
      }
    }

    if(simultaneous) {
      throw UnimplementedError("Simultaneous substitution not implemented");
    } else {
      var rv = this;
      for (final (old, sub) in sequence) {
        rv = rv._subs(old, sub);
        if(rv is! Basic) {
          break;
        }
      }
      return rv;
    }
  }

  T _subs(Basic<dynamic> old, Basic<dynamic> sub) {
    T fallback(Basic<dynamic> old, Basic<dynamic> sub) {
      bool hit = false;
      final args = List<Basic<dynamic>>.from(this.args);
      for(int i = 0; i < args.length; i++) {
        var arg = args[i];
        // if not hasattr(arg, '_evalSubs'): TODO
        //   continue TODO
        arg = arg._subs(old, sub);
        if(!isSame(arg, args[i])) {
          hit = true;
          args[i] = arg;
        }
      }
      if(hit) {
        final rv = func(args);
        // TODO hack2
        return rv;
      }
      return this as T;
    }

    if(isSame(this, old)) {
      return sub as T;
    }

    final rv = _evalSubs(old, sub);
    if(rv == null) {
      return fallback(old, sub);
    }
    return rv as T;
  }

  /// Override this stub if you want to do anything more than
  /// attempt a replacement of old with sub in this object's arguments.
  Basic? _evalSubs(Basic<dynamic> old, Basic<dynamic> sub) {
    return null;
  }

  /// Test whether any subexpression matches any of the patterns.
  ///
  /// Examples
  /// ========
  ///
  /// `(x^2 + sin(x*y)).has([z])`  ->  `false`
  ///
  /// `(x^2 + sin(x*y)).has([x, y, z])`  ->  `true`
  ///
  /// `x.has([x])`  ->  `true`
  ///
  /// Note [has] is a structural algorithm with no knowledge of
  /// mathematics.
  ///
  /// expr.has(patterns) is exactly equivalent to
  /// `patterns.any((p) => expr.has([p])). In particular, `false` is returned
  /// when the list of paterns is empty.
  ///
  /// `x.has([])`  ->  `false`
  bool has(List<dynamic> patterns) {
    return _has(iterArgs, patterns);
  }

  bool _has(Iterable<Basic<dynamic>> Function(Basic<dynamic>) iterArgs, List<dynamic> patterns) {
    final Set<Type> typeSet = {};
    final Set<Basic> pSet = {};

    for(final p in patterns) {
      if(p is Type) {
        typeSet.add(p);
      } else if(p is Basic) {
        pSet.add(p);
      }
    }

    for(final i in iterArgs(this)) {
      if(pSet.contains(i)) {
        return true;
      }
      if(typeSet.contains(i.runtimeType)) {
        return true;
      }
    }

    // TODO add matcher implementation

    return false;
  }

  /// Return true if this has any of the patterns in s as a
  /// free argument, else false. This is like `Basic.hasFree`
  /// but this will only report exact argument matches.
  bool hasXFree(Set<Basic<dynamic>> s) {
    for(final a in iterFreeArgs(this)) {
      if(s.contains(a)) {
        return true;
      }
    }
    return false;
  }

  Basic simplify({double ratio = 1.7, bool inverse = false,}) {
    return s.simplify(this, ratio: ratio, inverse: inverse);
  }

  Basic<dynamic> asDummy() {
    Basic<dynamic> can(Basic<dynamic> x) {
      throw UnimplementedError("can needs to be implemented in asDummy");
    }
    if(!this.has([Symbol])) {
      return this;
    }
    return replace(
      (Basic<dynamic> x) => x.boundSymbols != null,
      can,
      simultaneous: false,
    );
  }

  Basic<dynamic> replace(bool Function(Basic<dynamic> v) query, Basic<dynamic> Function(Basic<dynamic> expr) value, {bool simultaneous=true}) {
    Basic<dynamic> _value(expr, result) => value(expr);

    Basic<dynamic> walk(Basic<dynamic> rv, Basic<dynamic> Function(Basic<dynamic>) F) {
      final args = rv.args;
      if(args.isNotEmpty) {
        final newArgs = [
          for(final a in args)
            walk(a, F),
        ];
        if(args != newArgs) {
          // TODO above comparison probably needs to be deep
          rv = rv.func(newArgs);
          if(simultaneous) {
            // if rv is something that was already
            // matched (that was changed) then skip
            // applying F again
            for(int i = 0; i < args.length; i++) {
              if(rv == args[i] && args[i] != newArgs[i]) {
                return rv;
              }
            }
          }
        }
      }
      return F(rv);
    }

    Basic<dynamic> recReplace(Basic<dynamic> expr) {
      final result = query(expr);
      if(result) {
        final v = _value(expr, result);
        if(v != expr) {
          expr = v;
        }
      }
      return expr;
    }

    final rv = walk(this, recReplace);
    return rv;
  }

  Set<Basic>? get boundSymbols {
    // TODO override in necessary base classes
    return null;
  }

  /// Return a mapping from any variable defined in
  /// [boundSymbols] to Symbols that do not clash
  /// with any free symbols in the expression.
  Map<Basic, Symbol> get canonicalVariables {
    final bound = boundSymbols;
    if(bound == null) {
      return {};
    }
    final Iterator dums = numberedSymbols(prefix: '_').iterator;
    final reps = <Basic, Symbol>{};
    // watch out for free symbol that are not in bound symbols;
    // those that are in bound symbols are about to get changed

    // XXX: freeSymbols only returns particular kinds of expressions that
    // generally have a .name attribute. There is not a proper class/type
    // that represents this.
    final names = freeSymbols().difference(bound.toSet()).map((i) => (i as Symbol).name).toSet();
    for(final b in bound) {
      dums.moveNext();
      var d = dums.current;
      if (b is Symbol) {
        while (names.contains(d.name) && dums.moveNext()) {
          d = dums.current;
        }
      }
      reps[b] = d;
    }
    return reps;
  }

  /// Return true if a and b are structurally the same, else false.
  /// If [approx] is supplied, it will be used to test whether two
  /// numbers are the same or not. By default, only numbers of the
  /// same type will compare equal, so S.Half != Float(0.5).
  bool isSame(Basic<dynamic> a, Basic<dynamic> b, [bool Function(Basic, Basic)? approx]) {
    for(final t in zipLongest(postorderTraversal(a), postorderTraversal(b))) {
      final (a, b) = t;
      if(a == null || b == null) {
        return false;
      }
      if (a is Number) {
        if (b is! Number) {
          return false;
        }
        if (approx != null) {
          return approx(a, b);
        }
      }
      if (a != b || a.runtimeType != b.runtimeType) {
        return false;
      }
    }
    return true;
  }
}

List<String> orderingOfClasses = [
  // singleton numbers
  'Zero', 'One', 'Half', 'Infinity', 'NaN', 'NegativeOne', 'NegativeInfinity',
  // numbers
  'Integer', 'Rational', 'Float',
  // singleton symbols
  'Exp1', 'Pi', 'ImaginaryUnit',
  // symbols
  'Symbol', 'Wild',
  // arithmetic operations
  'Pow', 'Mul', 'Add',
  // function values
  'Derivative', 'Integral',
  // defined singleton functions
  'Abs', 'Sign', 'Sqrt',
  'Floor', 'Ceiling',
  'Re', 'Im', 'Arg',
  'Conjugate',
  'Exp', 'Log',
  'Sin', 'Cos', 'Tan', 'Cot', 'ASin', 'ACos', 'ATan', 'ACot',
  'Sinh', 'Cosh', 'Tanh', 'Coth', 'ASinh', 'ACosh', 'ATanh', 'ACoth',
  'RisingFactorial', 'FallingFactorial',
  'factorial', 'binomial',
  'Gamma', 'LowerGamma', 'UpperGamma', 'PolyGamma',
  'Erf',
  // special polynomials
  'Chebyshev', 'Chebyshev2',
  // undefined functions
  'Function', 'WildFunction',
  // anonymous functions
  'Lambda',
  // Landau O symbol
  'Order',
  // relational operations
  'Equality', 'Unequality', 'StrictGreaterThan', 'StrictLessThan',
  'GreaterThan', 'LessThan',
];

int _compareName(String n1, String n2) {
  if(n1 == n2) {
    return 0;
  }

  final UNKNOWN = orderingOfClasses.length + 1;
  int i1 = orderingOfClasses.indexOf(n1);
  int i2 = orderingOfClasses.indexOf(n2);
  if(i1 == -1) i1 = UNKNOWN;
  if(i2 == -1) i2 = UNKNOWN;
  if(i1 == UNKNOWN && i2 == UNKNOWN) {
    return n1.compareTo(n2);
  }
  return i1.compareTo(i2);
}

/// Return -1, 0, 1 if the object is less than, equal,
/// or greater than other in a canonical sense.
/// Non-Basic are always greater than Basic.
/// If both names of the classes being compared appear
/// in the `orderingOfClasses` then the ordering will
/// depend on the appearance of the names there.
/// If either does not appear in that list, then the
/// comparison is based on the class name.
/// If the names are the same then a comparison is made
/// on the length of the hashable content.
/// Items of the equal-lengthed contents are then
/// successively compared using the same rules. If there
/// is never a difference then 0 is returned.
int compare(Basic<dynamic> self, Basic<dynamic> other) {
  if(self == other) {
    return 0;
  }
  final n1 = self.runtimeType.toString();
  final n2 = other.runtimeType.toString();
  final c = _compareName(n1, n2);
  if(c != 0) {
    return c;
  }

  throw UnimplementedError("Need to finish implementing compare in Basic");
}


// TODO make these evaluate and calculate assumption logic lazily for efficiency
mixin class DefaultAssumptions {
  Assumptions _explicitAssumptions = Assumptions();
  Assumptions? _derivedAssumptions;

  bool? get assumeCommutative {
    _deriveAssumptions();
    return _derivedAssumptions!.commutative;
  }
  bool? get assumeComplex {
    _deriveAssumptions();
    return _derivedAssumptions!.complex;
  }
  bool? get assumeImaginary {
    _deriveAssumptions();
    return _derivedAssumptions!.imaginary;
  }
  bool? get assumeReal {
    _deriveAssumptions();
    return _derivedAssumptions!.real;
  }
  bool? get assumeExtendedReal {
    _deriveAssumptions();
    return _derivedAssumptions!.extendedReal;
  }
  bool? get assumeInteger {
    _deriveAssumptions();
    return _derivedAssumptions!.integer;
  }
  bool? get assumeNonInteger {
    _deriveAssumptions();
    return _derivedAssumptions!.nonInteger;
  }
  bool? get assumeOdd {
    _deriveAssumptions();
    return _derivedAssumptions!.odd;
  }
  bool? get assumeEven {
    _deriveAssumptions();
    return _derivedAssumptions!.even;
  }
  bool? get assumePrime {
    _deriveAssumptions();
    return _derivedAssumptions!.prime;
  }
  bool? get assumeComposite {
    _deriveAssumptions();
    return _derivedAssumptions!.composite;
  }
  bool? get assumeZero {
    _deriveAssumptions();
    return _derivedAssumptions!.zero;
  }
  bool? get assumeNonzero {
    _deriveAssumptions();
    return _derivedAssumptions!.nonzero;
  }
  bool? get assumeRational {
    _deriveAssumptions();
    return _derivedAssumptions!.rational;
  }
  bool? get assumeAlgebraic {
    _deriveAssumptions();
    return _derivedAssumptions!.algebraic;
  }
  bool? get assumeTranscendental {
    _deriveAssumptions();
    return _derivedAssumptions!.transcendental;
  }
  bool? get assumeIrrational {
    _deriveAssumptions();
    return _derivedAssumptions!.irrational;
  }
  bool? get assumeFinite {
    _deriveAssumptions();
    return _derivedAssumptions!.finite;
  }
  bool? get assumeInfinite {
    _deriveAssumptions();
    return _derivedAssumptions!.infinite;
  }
  bool? get assumeNegative {
    _deriveAssumptions();
    return _derivedAssumptions!.negative;
  }
  bool? get assumeNonNegative {
    _deriveAssumptions();
    return _derivedAssumptions!.nonNegative;
  }
  bool? get assumePositive {
    _deriveAssumptions();
    return _derivedAssumptions!.positive;
  }
  bool? get assumeNonPositive {
    _deriveAssumptions();
    return _derivedAssumptions!.nonPositive;
  }
  bool? get assumeExtendedNegative {
    _deriveAssumptions();
    return _derivedAssumptions!.extendedNegative;
  }
  bool? get assumeExtendedNonNegative {
    _deriveAssumptions();
    return _derivedAssumptions!.extendedNonNegative;
  }
  bool? get assumeExtendedPositive {
    _deriveAssumptions();
    return _derivedAssumptions!.extendedPositive;
  }
  bool? get assumeExtendedNonPositive {
    _deriveAssumptions();
    return _derivedAssumptions!.extendedNonPositive;
  }
  bool? get assumeExtendedNonzero {
    _deriveAssumptions();
    return _derivedAssumptions!.extendedNonzero;
  }
  bool? get assumeHermitian {
    _deriveAssumptions();
    return _derivedAssumptions!.hermitian;
  }
  bool? get assumeAntiHermitian {
    _deriveAssumptions();
    return _derivedAssumptions!.antiHermitian;
  }

  static const unspecified = -1;

  void addPrecomputedAssumptions(Assumptions assumptions) {
    assert(_derivedAssumptions == null, "Assumptions cannot be changed after they're accessed for the first time");
    _derivedAssumptions = assumptions.copy();
  }

  void addAssumptions({
    dynamic commutative = unspecified,
    dynamic complex = unspecified,
    dynamic imaginary = unspecified,
    dynamic real = unspecified,
    dynamic extendedReal = unspecified,
    dynamic integer = unspecified,
    dynamic nonInteger = unspecified,
    dynamic odd = unspecified,
    dynamic even = unspecified,
    dynamic prime = unspecified,
    dynamic composite = unspecified,
    dynamic zero = unspecified,
    dynamic nonzero = unspecified,
    dynamic rational = unspecified,
    dynamic algebraic = unspecified,
    dynamic transcendental = unspecified,
    dynamic irrational = unspecified,
    dynamic finite = unspecified,
    dynamic infinite = unspecified,
    dynamic negative = unspecified,
    dynamic nonNegative = unspecified,
    dynamic positive = unspecified,
    dynamic nonPositive = unspecified,
    dynamic extendedNegative = unspecified,
    dynamic extendedNonNegative = unspecified,
    dynamic extendedPositive = unspecified,
    dynamic extendedNonPositive = unspecified,
    dynamic extendedNonzero = unspecified,
    dynamic hermitian = unspecified,
    dynamic antiHermitian = unspecified,
  }) {
    assert(_derivedAssumptions == null, "Assumptions cannot be changed after they're accessed for the first time");

    final givenAssumptions = Assumptions(
      commutative: (commutative is bool?) ? commutative: null,
      complex: (complex is bool?) ? complex: null,
      imaginary: (imaginary is bool?) ? imaginary: null,
      real: (real is bool?) ? real: null,
      extendedReal: (extendedReal is bool?) ? extendedReal: null,
      integer: (integer is bool?) ? integer: null,
      nonInteger: (nonInteger is bool?) ? nonInteger: null,
      odd: (odd is bool?) ? odd: null,
      even: (even is bool?) ? even: null,
      prime: (prime is bool?) ? prime: null,
      composite: (composite is bool?) ? composite: null,
      zero: (zero is bool?) ? zero: null,
      nonzero: (nonzero is bool?) ? nonzero: null,
      rational: (rational is bool?) ? rational: null,
      algebraic: (algebraic is bool?) ? algebraic: null,
      transcendental: (transcendental is bool?) ? transcendental: null,
      irrational: (irrational is bool?) ? irrational: null,
      finite: (finite is bool?) ? finite: null,
      infinite: (infinite is bool?) ? infinite: null,
      negative: (negative is bool?) ? negative: null,
      nonNegative: (nonNegative is bool?) ? nonNegative: null,
      positive: (positive is bool?) ? positive: null,
      nonPositive: (nonPositive is bool?) ? nonPositive: null,
      extendedNegative: (extendedNegative is bool?) ? extendedNegative: null,
      extendedNonNegative: (extendedNonNegative is bool?) ? extendedNonNegative: null,
      extendedPositive: (extendedPositive is bool?) ? extendedPositive: null,
      extendedNonPositive: (extendedNonPositive is bool?) ? extendedNonPositive: null,
      extendedNonzero: (extendedNonzero is bool?) ? extendedNonzero: null,
      hermitian: (hermitian is bool?) ? hermitian: null,
      antiHermitian: (antiHermitian is bool?) ? antiHermitian: null,
    );

    final assumptionsToRemove = Assumptions(
      commutative: (commutative is bool? && commutative == null) ? true : null,
      complex: (complex is bool? && complex == null) ? true : null,
      imaginary: (imaginary is bool? && imaginary == null) ? true : null,
      real: (real is bool? && real == null) ? true : null,
      extendedReal: (extendedReal is bool? && extendedReal == null) ? true : null,
      integer: (integer is bool? && integer == null) ? true : null,
      nonInteger: (nonInteger is bool? && nonInteger == null) ? true : null,
      odd: (odd is bool? && odd == null) ? true : null,
      even: (even is bool? && even == null) ? true : null,
      prime: (prime is bool? && prime == null) ? true : null,
      composite: (composite is bool? && composite == null) ? true : null,
      zero: (zero is bool? && zero == null) ? true : null,
      nonzero: (nonzero is bool? && nonzero == null) ? true : null,
      rational: (rational is bool? && rational == null) ? true : null,
      algebraic: (algebraic is bool? && algebraic == null) ? true : null,
      transcendental: (transcendental is bool? && transcendental == null) ? true : null,
      irrational: (irrational is bool? && irrational == null) ? true : null,
      finite: (finite is bool? && finite == null) ? true : null,
      infinite: (infinite is bool? && infinite == null) ? true : null,
      negative: (negative is bool? && negative == null) ? true : null,
      nonNegative: (nonNegative is bool? && nonNegative == null) ? true : null,
      positive: (positive is bool? && positive == null) ? true : null,
      nonPositive: (nonPositive is bool? && nonPositive == null) ? true : null,
      extendedNegative: (extendedNegative is bool? && extendedNegative == null) ? true : null,
      extendedNonNegative: (extendedNonNegative is bool? && extendedNonNegative == null) ? true : null,
      extendedPositive: (extendedPositive is bool? && extendedPositive == null) ? true : null,
      extendedNonPositive: (extendedNonPositive is bool? && extendedNonPositive == null) ? true : null,
      extendedNonzero: (extendedNonzero is bool? && extendedNonzero == null) ? true : null,
      hermitian: (hermitian is bool? && hermitian == null) ? true : null,
      antiHermitian: (antiHermitian is bool? && antiHermitian == null) ? true : null,
    );

    _explicitAssumptions = givenAssumptions.inherit(_explicitAssumptions);
    _explicitAssumptions = _explicitAssumptions.remove(assumptionsToRemove);
  }
  
  void _deriveAssumptions() {
    if(_derivedAssumptions == null) {
      final assumptionsKB = StdFactKB(_explicitAssumptions);
      _derivedAssumptions = assumptionsKB.toAssumptions();
    }
  }
}

interface class Atom {

}

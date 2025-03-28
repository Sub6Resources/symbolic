// Do NOT manually edit this file.
// Instead, run `bin/ask_update.dart`.

import 'facts.dart';
import 'logic.dart';

final definedFacts = [
  LogicAtom('algebraic'),
  LogicAtom('antiHermitian'),
  LogicAtom('commutative'),
  LogicAtom('complex'),
  LogicAtom('composite'),
  LogicAtom('even'),
  LogicAtom('extendedNegative'),
  LogicAtom('extendedNonNegative'),
  LogicAtom('extendedNonPositive'),
  LogicAtom('extendedNonzero'),
  LogicAtom('extendedPositive'),
  LogicAtom('extendedReal'),
  LogicAtom('finite'),
  LogicAtom('hermitian'),
  LogicAtom('imaginary'),
  LogicAtom('infinite'),
  LogicAtom('integer'),
  LogicAtom('irrational'),
  LogicAtom('negative'),
  LogicAtom('nonInteger'),
  LogicAtom('nonNegative'),
  LogicAtom('nonPositive'),
  LogicAtom('nonzero'),
  LogicAtom('odd'),
  LogicAtom('positive'),
  LogicAtom('prime'),
  LogicAtom('rational'),
  LogicAtom('real'),
  LogicAtom('transcendental'),
  LogicAtom('zero'),
]; // definedFacts

final fullImplications = {
  // Implications of LogicAtom('algebraic') = true:
  (LogicAtom('algebraic'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('infinite'), false),
    (LogicAtom('transcendental'), false),
  },
  // Implications of LogicAtom('algebraic') = false:
  (LogicAtom('algebraic'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('antiHermitian') = true:
  (LogicAtom('antiHermitian'), true): <(Logic, bool)>{},
  // Implications of LogicAtom('antiHermitian') = false:
  (LogicAtom('antiHermitian'), false): <(Logic, bool)>{
    (LogicAtom('imaginary'), false),
  },
  // Implications of LogicAtom('commutative') = true:
  (LogicAtom('commutative'), true): <(Logic, bool)>{},
  // Implications of LogicAtom('commutative') = false:
  (LogicAtom('commutative'), false): <(Logic, bool)>{
    (LogicAtom('algebraic'), false),
    (LogicAtom('complex'), false),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), false),
    (LogicAtom('extendedNonPositive'), false),
    (LogicAtom('extendedNonzero'), false),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('extendedReal'), false),
    (LogicAtom('imaginary'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('real'), false),
    (LogicAtom('transcendental'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('complex') = true:
  (LogicAtom('complex'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('infinite'), false),
  },
  // Implications of LogicAtom('complex') = false:
  (LogicAtom('complex'), false): <(Logic, bool)>{
    (LogicAtom('algebraic'), false),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('imaginary'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('real'), false),
    (LogicAtom('transcendental'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('composite') = true:
  (LogicAtom('composite'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), true),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), true),
    (LogicAtom('extendedNonPositive'), false),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedPositive'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('integer'), true),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('nonNegative'), true),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), true),
    (LogicAtom('positive'), true),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), true),
    (LogicAtom('real'), true),
    (LogicAtom('transcendental'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('composite') = false:
  (LogicAtom('composite'), false): <(Logic, bool)>{},
  // Implications of LogicAtom('even') = true:
  (LogicAtom('even'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), true),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('integer'), true),
    (LogicAtom('irrational'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('rational'), true),
    (LogicAtom('real'), true),
    (LogicAtom('transcendental'), false),
  },
  // Implications of LogicAtom('even') = false:
  (LogicAtom('even'), false): <(Logic, bool)>{
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('extendedNegative') = true:
  (LogicAtom('extendedNegative'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('extendedNonNegative'), false),
    (LogicAtom('extendedNonPositive'), true),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('extendedNegative') = false:
  (LogicAtom('extendedNegative'), false): <(Logic, bool)>{
    (LogicAtom('negative'), false),
  },
  // Implications of LogicAtom('extendedNonNegative') = true:
  (LogicAtom('extendedNonNegative'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('negative'), false),
  },
  // Implications of LogicAtom('extendedNonNegative') = false:
  (LogicAtom('extendedNonNegative'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('extendedNonPositive') = true:
  (LogicAtom('extendedNonPositive'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
  },
  // Implications of LogicAtom('extendedNonPositive') = false:
  (LogicAtom('extendedNonPositive'), false): <(Logic, bool)>{
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('extendedNonzero') = true:
  (LogicAtom('extendedNonzero'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('extendedNonzero') = false:
  (LogicAtom('extendedNonzero'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
  },
  // Implications of LogicAtom('extendedPositive') = true:
  (LogicAtom('extendedPositive'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), true),
    (LogicAtom('extendedNonPositive'), false),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('extendedPositive') = false:
  (LogicAtom('extendedPositive'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
  },
  // Implications of LogicAtom('extendedReal') = true:
  (LogicAtom('extendedReal'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('imaginary'), false),
  },
  // Implications of LogicAtom('extendedReal') = false:
  (LogicAtom('extendedReal'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), false),
    (LogicAtom('extendedNonPositive'), false),
    (LogicAtom('extendedNonzero'), false),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('real'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('finite') = true:
  (LogicAtom('finite'), true): <(Logic, bool)>{
    (LogicAtom('infinite'), false),
  },
  // Implications of LogicAtom('finite') = false:
  (LogicAtom('finite'), false): <(Logic, bool)>{
    (LogicAtom('algebraic'), false),
    (LogicAtom('complex'), false),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), true),
    (LogicAtom('integer'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('real'), false),
    (LogicAtom('transcendental'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('hermitian') = true:
  (LogicAtom('hermitian'), true): <(Logic, bool)>{},
  // Implications of LogicAtom('hermitian') = false:
  (LogicAtom('hermitian'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('real'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('imaginary') = true:
  (LogicAtom('imaginary'), true): <(Logic, bool)>{
    (LogicAtom('antiHermitian'), true),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), false),
    (LogicAtom('extendedNonPositive'), false),
    (LogicAtom('extendedNonzero'), false),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('extendedReal'), false),
    (LogicAtom('finite'), true),
    (LogicAtom('infinite'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('real'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('imaginary') = false:
  (LogicAtom('imaginary'), false): <(Logic, bool)>{},
  // Implications of LogicAtom('infinite') = true:
  (LogicAtom('infinite'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), false),
    (LogicAtom('complex'), false),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('finite'), false),
    (LogicAtom('imaginary'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('real'), false),
    (LogicAtom('transcendental'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('infinite') = false:
  (LogicAtom('infinite'), false): <(Logic, bool)>{
    (LogicAtom('finite'), true),
  },
  // Implications of LogicAtom('integer') = true:
  (LogicAtom('integer'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), true),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('rational'), true),
    (LogicAtom('real'), true),
    (LogicAtom('transcendental'), false),
  },
  // Implications of LogicAtom('integer') = false:
  (LogicAtom('integer'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('irrational') = true:
  (LogicAtom('irrational'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('nonInteger'), true),
    (LogicAtom('nonzero'), true),
    (LogicAtom('odd'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('real'), true),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('irrational') = false:
  (LogicAtom('irrational'), false): <(Logic, bool)>{},
  // Implications of LogicAtom('negative') = true:
  (LogicAtom('negative'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('extendedNegative'), true),
    (LogicAtom('extendedNonNegative'), false),
    (LogicAtom('extendedNonPositive'), true),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), true),
    (LogicAtom('nonzero'), true),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('real'), true),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('negative') = false:
  (LogicAtom('negative'), false): <(Logic, bool)>{},
  // Implications of LogicAtom('nonInteger') = true:
  (LogicAtom('nonInteger'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('nonInteger') = false:
  (LogicAtom('nonInteger'), false): <(Logic, bool)>{},
  // Implications of LogicAtom('nonNegative') = true:
  (LogicAtom('nonNegative'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('real'), true),
  },
  // Implications of LogicAtom('nonNegative') = false:
  (LogicAtom('nonNegative'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('nonPositive') = true:
  (LogicAtom('nonPositive'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('extendedNonPositive'), true),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('real'), true),
  },
  // Implications of LogicAtom('nonPositive') = false:
  (LogicAtom('nonPositive'), false): <(Logic, bool)>{
    (LogicAtom('negative'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('nonzero') = true:
  (LogicAtom('nonzero'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('real'), true),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('nonzero') = false:
  (LogicAtom('nonzero'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
  },
  // Implications of LogicAtom('odd') = true:
  (LogicAtom('odd'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), true),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('even'), false),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('integer'), true),
    (LogicAtom('irrational'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('nonzero'), true),
    (LogicAtom('rational'), true),
    (LogicAtom('real'), true),
    (LogicAtom('transcendental'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('odd') = false:
  (LogicAtom('odd'), false): <(Logic, bool)>{},
  // Implications of LogicAtom('positive') = true:
  (LogicAtom('positive'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), true),
    (LogicAtom('extendedNonPositive'), false),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedPositive'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonNegative'), true),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), true),
    (LogicAtom('real'), true),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('positive') = false:
  (LogicAtom('positive'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('prime'), false),
  },
  // Implications of LogicAtom('prime') = true:
  (LogicAtom('prime'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), true),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), true),
    (LogicAtom('extendedNonPositive'), false),
    (LogicAtom('extendedNonzero'), true),
    (LogicAtom('extendedPositive'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('integer'), true),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('nonNegative'), true),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), true),
    (LogicAtom('positive'), true),
    (LogicAtom('rational'), true),
    (LogicAtom('real'), true),
    (LogicAtom('transcendental'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('prime') = false:
  (LogicAtom('prime'), false): <(Logic, bool)>{},
  // Implications of LogicAtom('rational') = true:
  (LogicAtom('rational'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), true),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('real'), true),
    (LogicAtom('transcendental'), false),
  },
  // Implications of LogicAtom('rational') = false:
  (LogicAtom('rational'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('real') = true:
  (LogicAtom('real'), true): <(Logic, bool)>{
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
  },
  // Implications of LogicAtom('real') = false:
  (LogicAtom('real'), false): <(Logic, bool)>{
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonNegative'), false),
    (LogicAtom('nonPositive'), false),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('transcendental') = true:
  (LogicAtom('transcendental'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), false),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), false),
    (LogicAtom('finite'), true),
    (LogicAtom('infinite'), false),
    (LogicAtom('integer'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), false),
    (LogicAtom('zero'), false),
  },
  // Implications of LogicAtom('transcendental') = false:
  (LogicAtom('transcendental'), false): <(Logic, bool)>{},
  // Implications of LogicAtom('zero') = true:
  (LogicAtom('zero'), true): <(Logic, bool)>{
    (LogicAtom('algebraic'), true),
    (LogicAtom('commutative'), true),
    (LogicAtom('complex'), true),
    (LogicAtom('composite'), false),
    (LogicAtom('even'), true),
    (LogicAtom('extendedNegative'), false),
    (LogicAtom('extendedNonNegative'), true),
    (LogicAtom('extendedNonPositive'), true),
    (LogicAtom('extendedNonzero'), false),
    (LogicAtom('extendedPositive'), false),
    (LogicAtom('extendedReal'), true),
    (LogicAtom('finite'), true),
    (LogicAtom('hermitian'), true),
    (LogicAtom('imaginary'), false),
    (LogicAtom('infinite'), false),
    (LogicAtom('integer'), true),
    (LogicAtom('irrational'), false),
    (LogicAtom('negative'), false),
    (LogicAtom('nonInteger'), false),
    (LogicAtom('nonNegative'), true),
    (LogicAtom('nonPositive'), true),
    (LogicAtom('nonzero'), false),
    (LogicAtom('odd'), false),
    (LogicAtom('positive'), false),
    (LogicAtom('prime'), false),
    (LogicAtom('rational'), true),
    (LogicAtom('real'), true),
    (LogicAtom('transcendental'), false),
  },
  // Implications of LogicAtom('zero') = false:
  (LogicAtom('zero'), false): <(Logic, bool)>{},
}; // fullImplications

final prereq = {
  // facts that could determine the value of LogicAtom('algebraic')
  LogicAtom('algebraic'): {
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('finite'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('odd'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('antiHermitian')
  LogicAtom('antiHermitian'): {
    LogicAtom('imaginary'),
  },

  // facts that could determine the value of LogicAtom('commutative')
  LogicAtom('commutative'): {
    LogicAtom('algebraic'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('imaginary'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonInteger'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('complex')
  LogicAtom('complex'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('finite'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('composite')
  LogicAtom('composite'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonInteger'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('even')
  LogicAtom('even'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('nonInteger'),
    LogicAtom('odd'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('extendedNegative')
  LogicAtom('extendedNegative'): {
    LogicAtom('commutative'),
    LogicAtom('composite'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('imaginary'),
    LogicAtom('negative'),
    LogicAtom('nonNegative'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('extendedNonNegative')
  LogicAtom('extendedNonNegative'): {
    LogicAtom('commutative'),
    LogicAtom('composite'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('imaginary'),
    LogicAtom('negative'),
    LogicAtom('nonNegative'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('extendedNonPositive')
  LogicAtom('extendedNonPositive'): {
    LogicAtom('commutative'),
    LogicAtom('composite'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('imaginary'),
    LogicAtom('negative'),
    LogicAtom('nonPositive'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('extendedNonzero')
  LogicAtom('extendedNonzero'): {
    LogicAtom('commutative'),
    LogicAtom('composite'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('imaginary'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonInteger'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('extendedPositive')
  LogicAtom('extendedPositive'): {
    LogicAtom('commutative'),
    LogicAtom('composite'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedReal'),
    LogicAtom('imaginary'),
    LogicAtom('negative'),
    LogicAtom('nonPositive'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('extendedReal')
  LogicAtom('extendedReal'): {
    LogicAtom('commutative'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('imaginary'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonInteger'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('finite')
  LogicAtom('finite'): {
    LogicAtom('algebraic'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('hermitian')
  LogicAtom('hermitian'): {
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('imaginary')
  LogicAtom('imaginary'): {
    LogicAtom('antiHermitian'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonInteger'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('infinite')
  LogicAtom('infinite'): {
    LogicAtom('algebraic'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('finite'),
    LogicAtom('imaginary'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('integer')
  LogicAtom('integer'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('irrational'),
    LogicAtom('nonInteger'),
    LogicAtom('odd'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('irrational')
  LogicAtom('irrational'): {
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('odd'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('negative')
  LogicAtom('negative'): {
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('nonInteger')
  LogicAtom('nonInteger'): {
    LogicAtom('commutative'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedReal'),
    LogicAtom('imaginary'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('odd'),
    LogicAtom('prime'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('nonNegative')
  LogicAtom('nonNegative'): {
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('negative'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('nonPositive')
  LogicAtom('nonPositive'): {
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('negative'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('nonzero')
  LogicAtom('nonzero'): {
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('odd')
  LogicAtom('odd'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('even'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('nonInteger'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('positive')
  LogicAtom('positive'): {
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('negative'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('prime'),
    LogicAtom('real'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('prime')
  LogicAtom('prime'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonInteger'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('positive'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('rational')
  LogicAtom('rational'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('odd'),
    LogicAtom('prime'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('real')
  LogicAtom('real'): {
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('transcendental')
  LogicAtom('transcendental'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('finite'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('odd'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('zero'),
  },

  // facts that could determine the value of LogicAtom('zero')
  LogicAtom('zero'): {
    LogicAtom('algebraic'),
    LogicAtom('commutative'),
    LogicAtom('complex'),
    LogicAtom('composite'),
    LogicAtom('even'),
    LogicAtom('extendedNegative'),
    LogicAtom('extendedNonNegative'),
    LogicAtom('extendedNonPositive'),
    LogicAtom('extendedNonzero'),
    LogicAtom('extendedPositive'),
    LogicAtom('extendedReal'),
    LogicAtom('finite'),
    LogicAtom('hermitian'),
    LogicAtom('imaginary'),
    LogicAtom('infinite'),
    LogicAtom('integer'),
    LogicAtom('irrational'),
    LogicAtom('negative'),
    LogicAtom('nonInteger'),
    LogicAtom('nonNegative'),
    LogicAtom('nonPositive'),
    LogicAtom('nonzero'),
    LogicAtom('odd'),
    LogicAtom('positive'),
    LogicAtom('prime'),
    LogicAtom('rational'),
    LogicAtom('real'),
    LogicAtom('transcendental'),
  },
}; // prereq

// Note: the order of the beta rules is used in the betaTriggers
final betaRules = [
  // Rules implying LogicAtom('composite') = true
  (
    {
      (LogicAtom('even'), true),
      (LogicAtom('positive'), true),
      (LogicAtom('prime'), false)
    },
    (LogicAtom('composite'), true)
  ),

  // Rules implying LogicAtom('even') = false
  (
    {
      (LogicAtom('composite'), false),
      (LogicAtom('positive'), true),
      (LogicAtom('prime'), false)
    },
    (LogicAtom('even'), false)
  ),

  // Rules implying LogicAtom('even') = true
  (
    {(LogicAtom('integer'), true), (LogicAtom('odd'), false)},
    (LogicAtom('even'), true)
  ),

  // Rules implying LogicAtom('extendedNegative') = true
  (
    {
      (LogicAtom('extendedPositive'), false),
      (LogicAtom('extendedReal'), true),
      (LogicAtom('zero'), false)
    },
    (LogicAtom('extendedNegative'), true)
  ),
  (
    {
      (LogicAtom('extendedNonPositive'), true),
      (LogicAtom('extendedNonzero'), true)
    },
    (LogicAtom('extendedNegative'), true)
  ),

  // Rules implying LogicAtom('extendedNonNegative') = true
  (
    {(LogicAtom('extendedNegative'), false), (LogicAtom('extendedReal'), true)},
    (LogicAtom('extendedNonNegative'), true)
  ),

  // Rules implying LogicAtom('extendedNonPositive') = true
  (
    {(LogicAtom('extendedPositive'), false), (LogicAtom('extendedReal'), true)},
    (LogicAtom('extendedNonPositive'), true)
  ),

  // Rules implying LogicAtom('extendedNonzero') = true
  (
    {(LogicAtom('extendedReal'), true), (LogicAtom('zero'), false)},
    (LogicAtom('extendedNonzero'), true)
  ),

  // Rules implying LogicAtom('extendedPositive') = true
  (
    {
      (LogicAtom('extendedNegative'), false),
      (LogicAtom('extendedReal'), true),
      (LogicAtom('zero'), false)
    },
    (LogicAtom('extendedPositive'), true)
  ),
  (
    {
      (LogicAtom('extendedNonNegative'), true),
      (LogicAtom('extendedNonzero'), true)
    },
    (LogicAtom('extendedPositive'), true)
  ),

  // Rules implying LogicAtom('extendedReal') = false
  (
    {(LogicAtom('infinite'), false), (LogicAtom('real'), false)},
    (LogicAtom('extendedReal'), false)
  ),
  (
    {
      (LogicAtom('extendedNegative'), false),
      (LogicAtom('extendedPositive'), false),
      (LogicAtom('zero'), false)
    },
    (LogicAtom('extendedReal'), false)
  ),

  // Rules implying LogicAtom('infinite') = true
  (
    {(LogicAtom('extendedReal'), true), (LogicAtom('real'), false)},
    (LogicAtom('infinite'), true)
  ),

  // Rules implying LogicAtom('irrational') = true
  (
    {(LogicAtom('rational'), false), (LogicAtom('real'), true)},
    (LogicAtom('irrational'), true)
  ),

  // Rules implying LogicAtom('negative') = true
  (
    {
      (LogicAtom('positive'), false),
      (LogicAtom('real'), true),
      (LogicAtom('zero'), false)
    },
    (LogicAtom('negative'), true)
  ),
  (
    {(LogicAtom('nonPositive'), true), (LogicAtom('nonzero'), true)},
    (LogicAtom('negative'), true)
  ),
  (
    {(LogicAtom('extendedNegative'), true), (LogicAtom('finite'), true)},
    (LogicAtom('negative'), true)
  ),

  // Rules implying LogicAtom('nonInteger') = true
  (
    {(LogicAtom('extendedReal'), true), (LogicAtom('integer'), false)},
    (LogicAtom('nonInteger'), true)
  ),

  // Rules implying LogicAtom('nonNegative') = true
  (
    {(LogicAtom('negative'), false), (LogicAtom('real'), true)},
    (LogicAtom('nonNegative'), true)
  ),
  (
    {(LogicAtom('extendedNonNegative'), true), (LogicAtom('finite'), true)},
    (LogicAtom('nonNegative'), true)
  ),

  // Rules implying LogicAtom('nonPositive') = true
  (
    {(LogicAtom('positive'), false), (LogicAtom('real'), true)},
    (LogicAtom('nonPositive'), true)
  ),
  (
    {(LogicAtom('extendedNonPositive'), true), (LogicAtom('finite'), true)},
    (LogicAtom('nonPositive'), true)
  ),

  // Rules implying LogicAtom('nonzero') = true
  (
    {(LogicAtom('extendedNonzero'), true), (LogicAtom('finite'), true)},
    (LogicAtom('nonzero'), true)
  ),

  // Rules implying LogicAtom('odd') = true
  (
    {(LogicAtom('even'), false), (LogicAtom('integer'), true)},
    (LogicAtom('odd'), true)
  ),

  // Rules implying LogicAtom('positive') = false
  (
    {
      (LogicAtom('composite'), false),
      (LogicAtom('even'), true),
      (LogicAtom('prime'), false)
    },
    (LogicAtom('positive'), false)
  ),

  // Rules implying LogicAtom('positive') = true
  (
    {
      (LogicAtom('negative'), false),
      (LogicAtom('real'), true),
      (LogicAtom('zero'), false)
    },
    (LogicAtom('positive'), true)
  ),
  (
    {(LogicAtom('nonNegative'), true), (LogicAtom('nonzero'), true)},
    (LogicAtom('positive'), true)
  ),
  (
    {(LogicAtom('extendedPositive'), true), (LogicAtom('finite'), true)},
    (LogicAtom('positive'), true)
  ),

  // Rules implying LogicAtom('prime') = true
  (
    {
      (LogicAtom('composite'), false),
      (LogicAtom('even'), true),
      (LogicAtom('positive'), true)
    },
    (LogicAtom('prime'), true)
  ),

  // Rules implying LogicAtom('real') = false
  (
    {
      (LogicAtom('negative'), false),
      (LogicAtom('positive'), false),
      (LogicAtom('zero'), false)
    },
    (LogicAtom('real'), false)
  ),

  // Rules implying LogicAtom('real') = true
  (
    {(LogicAtom('extendedReal'), true), (LogicAtom('infinite'), false)},
    (LogicAtom('real'), true)
  ),
  (
    {(LogicAtom('extendedReal'), true), (LogicAtom('finite'), true)},
    (LogicAtom('real'), true)
  ),

  // Rules implying LogicAtom('transcendental') = true
  (
    {(LogicAtom('algebraic'), false), (LogicAtom('complex'), true)},
    (LogicAtom('transcendental'), true)
  ),

  // Rules implying LogicAtom('zero') = true
  (
    {
      (LogicAtom('extendedNegative'), false),
      (LogicAtom('extendedPositive'), false),
      (LogicAtom('extendedReal'), true)
    },
    (LogicAtom('zero'), true)
  ),
  (
    {
      (LogicAtom('negative'), false),
      (LogicAtom('positive'), false),
      (LogicAtom('real'), true)
    },
    (LogicAtom('zero'), true)
  ),
  (
    {
      (LogicAtom('extendedNonNegative'), true),
      (LogicAtom('extendedNonPositive'), true)
    },
    (LogicAtom('zero'), true)
  ),
  (
    {(LogicAtom('nonNegative'), true), (LogicAtom('nonPositive'), true)},
    (LogicAtom('zero'), true)
  ),
]; // betaRules
final betaTriggers = {
  (LogicAtom('algebraic'), false): <int>[32, 11, 3, 8, 29, 14, 25, 13, 17, 7],
  (LogicAtom('algebraic'), true): <int>[10, 30, 31, 27, 16, 21, 19, 22],
  (LogicAtom('antiHermitian'), false): <int>[],
  (LogicAtom('commutative'), false): <int>[],
  (LogicAtom('complex'), false): <int>[10, 12, 11, 3, 8, 17, 7],
  (LogicAtom('complex'), true): <int>[32, 10, 30, 31, 27, 16, 21, 19, 22],
  (LogicAtom('composite'), false): <int>[28, 24, 1],
  (LogicAtom('composite'), true): <int>[23, 2],
  (LogicAtom('even'), false): <int>[23, 11, 3, 8, 29, 14, 25, 7],
  (LogicAtom('even'), true): <int>[
    3,
    33,
    8,
    6,
    5,
    14,
    34,
    25,
    20,
    18,
    27,
    16,
    21,
    19,
    22,
    0,
    28,
    24,
    7
  ],
  (LogicAtom('extendedNegative'), false): <int>[11, 33, 8, 5, 29, 34, 25, 18],
  (LogicAtom('extendedNegative'), true): <int>[
    30,
    12,
    31,
    29,
    14,
    20,
    16,
    21,
    22,
    17
  ],
  (LogicAtom('extendedNonNegative'), false): <int>[11, 3, 6, 29, 14, 20, 7],
  (LogicAtom('extendedNonNegative'), true): <int>[
    30,
    12,
    31,
    33,
    8,
    9,
    6,
    29,
    34,
    25,
    18,
    19,
    35,
    17,
    7
  ],
  (LogicAtom('extendedNonPositive'), false): <int>[11, 8, 5, 29, 25, 18, 7],
  (LogicAtom('extendedNonPositive'), true): <int>[
    30,
    12,
    31,
    3,
    33,
    4,
    5,
    29,
    14,
    34,
    20,
    21,
    35,
    17,
    7
  ],
  (LogicAtom('extendedNonzero'), false): <int>[11, 33, 6, 5, 29, 34, 20, 18],
  (LogicAtom('extendedNonzero'), true): <int>[
    30,
    12,
    31,
    3,
    8,
    4,
    9,
    6,
    5,
    29,
    14,
    25,
    22,
    17
  ],
  (LogicAtom('extendedPositive'), false): <int>[11, 3, 33, 6, 29, 14, 34, 20],
  (LogicAtom('extendedPositive'), true): <int>[
    30,
    12,
    31,
    29,
    25,
    18,
    27,
    19,
    22,
    17
  ],
  (LogicAtom('extendedReal'), false): <int>[],
  (LogicAtom('extendedReal'), true): <int>[30, 12, 31, 3, 33, 8, 6, 5, 17, 7],
  (LogicAtom('finite'), false): <int>[11, 3, 8, 17, 7],
  (LogicAtom('finite'), true): <int>[10, 30, 31, 27, 16, 21, 19, 22],
  (LogicAtom('hermitian'), false): <int>[10, 12, 11, 3, 8, 17, 7],
  (LogicAtom('imaginary'), true): <int>[32],
  (LogicAtom('infinite'), false): <int>[10, 30, 31, 27, 16, 21, 19, 22],
  (LogicAtom('infinite'), true): <int>[11, 3, 8, 17, 7],
  (LogicAtom('integer'), false): <int>[11, 3, 8, 29, 14, 25, 17, 7],
  (LogicAtom('integer'), true): <int>[
    23,
    2,
    3,
    33,
    8,
    6,
    5,
    14,
    34,
    25,
    20,
    18,
    27,
    16,
    21,
    19,
    22,
    7
  ],
  (LogicAtom('irrational'), true): <int>[
    32,
    3,
    8,
    4,
    9,
    6,
    5,
    14,
    25,
    15,
    26,
    20,
    18,
    27,
    16,
    21,
    19
  ],
  (LogicAtom('negative'), false): <int>[29, 34, 25, 18],
  (LogicAtom('negative'), true): <int>[32, 13, 17],
  (LogicAtom('nonInteger'), true): <int>[
    30,
    12,
    31,
    3,
    8,
    4,
    9,
    6,
    5,
    29,
    14,
    25,
    22
  ],
  (LogicAtom('nonNegative'), false): <int>[11, 3, 8, 29, 14, 20, 7],
  (LogicAtom('nonNegative'), true): <int>[
    32,
    33,
    8,
    9,
    6,
    34,
    25,
    26,
    20,
    27,
    21,
    22,
    35,
    36,
    13,
    17,
    7
  ],
  (LogicAtom('nonPositive'), false): <int>[11, 3, 8, 29, 25, 18, 7],
  (LogicAtom('nonPositive'), true): <int>[
    32,
    3,
    33,
    4,
    5,
    14,
    34,
    15,
    18,
    16,
    19,
    22,
    35,
    36,
    13,
    17,
    7
  ],
  (LogicAtom('nonzero'), false): <int>[29, 34, 20, 18],
  (LogicAtom('nonzero'), true): <int>[
    32,
    3,
    8,
    4,
    9,
    6,
    5,
    14,
    25,
    15,
    26,
    20,
    18,
    27,
    16,
    21,
    19,
    13,
    17
  ],
  (LogicAtom('odd'), false): <int>[2],
  (LogicAtom('odd'), true): <int>[
    3,
    8,
    4,
    9,
    6,
    5,
    14,
    25,
    15,
    26,
    20,
    18,
    27,
    16,
    21,
    19
  ],
  (LogicAtom('positive'), false): <int>[29, 14, 34, 20],
  (LogicAtom('positive'), true): <int>[32, 0, 28, 1, 13, 17],
  (LogicAtom('prime'), false): <int>[0, 24, 1],
  (LogicAtom('prime'), true): <int>[23, 2],
  (LogicAtom('rational'), false): <int>[11, 3, 8, 29, 14, 25, 13, 17, 7],
  (LogicAtom('rational'), true): <int>[
    3,
    33,
    8,
    6,
    5,
    14,
    34,
    25,
    20,
    18,
    27,
    16,
    21,
    19,
    22,
    17,
    7
  ],
  (LogicAtom('real'), false): <int>[10, 12, 11, 3, 8, 17, 7],
  (LogicAtom('real'), true): <int>[
    32,
    3,
    33,
    8,
    6,
    5,
    14,
    34,
    25,
    20,
    18,
    27,
    16,
    21,
    19,
    22,
    13,
    17,
    7
  ],
  (LogicAtom('transcendental'), true): <int>[
    10,
    30,
    31,
    11,
    3,
    8,
    29,
    14,
    25,
    27,
    16,
    21,
    19,
    22,
    13,
    17,
    7
  ],
  (LogicAtom('zero'), false): <int>[11, 3, 8, 29, 14, 25, 7],
  (LogicAtom('zero'), true): <int>[],
}; // betaTriggers

final factRules = FactRules.pregenerated(
  betaRules,
  definedFacts.toSet(),
  fullImplications,
  betaTriggers,
  prereq,
);

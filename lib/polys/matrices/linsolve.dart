import 'package:symbolic/core/add.dart';
import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/mul.dart';
import 'package:symbolic/core/numbers.dart';
import 'package:symbolic/core/relational.dart';
import 'package:symbolic/polys/solvers.dart';

/// Convert a system [Expr]/[Eq] equations into dict form, returning
/// the coefficient dictionaries and a list of [syms]-independent terms
/// from each expression in [eqs].
(List<Map<Expr, Expr>>, List<Expr>) linearEqToDict(List<Basic<dynamic>> eqs, List<Expr> syms) {
  final coeffs = <Map<Expr, Expr>>[];
  final ind = <Expr>[];
  final symset = syms.toSet();
  for(final e in eqs) {
    if(e.isEquality && e is Equality) {
      var (coeff, terms) = _linEq2Dict(e.lhs, symset);
      var (cR, tR) = _linEq2Dict(e.rhs, symset);
      // there were no nonlinear errors so now
      // cancellation is allowed
      coeff -= cR;
      for(final entry in tR.entries) {
        if(terms.containsKey(entry.key)) {
          terms[entry.key] = terms[entry.key]! - entry.value;
        } else {
          terms[entry.key] = -entry.value;
        }
      }
      // don't store coefficients of 0, however
      // TODO filter terms
      coeffs.add(terms);
      ind.add(coeff);
    } else {
      final (c, d) = _linEq2Dict(e as Expr, symset);
      coeffs.add(d);
      ind.add(c);
    }
  }

  return (coeffs, ind);
}

(Expr, Map<Expr, Expr>) _linEq2Dict(Expr a, Set<Expr> symset) {
  if(symset.contains(a)) {
    return (Zero.instance, {a: One.instance});
  } else if(a.isAdd && a is Add) {
    final termsList = <Expr, List<Expr>>{};
    final coeffList = <Expr>[];
    for (final ai in a.args) {
      final (ci, ti) = _linEq2Dict(ai, symset);
      coeffList.add(ci);
      for(final entry in ti.entries) {
        final (mij, cij) = (entry.key, entry.value);
        if(!termsList.containsKey(mij)) {
          termsList[mij] = [];
        }
        termsList[mij]!.add(cij);
      }
    }
    final coeff = Add(coeffList);
    final terms = termsList.map((sym, coeffs) => MapEntry(sym, Add(coeffs)));
    return (coeff, terms);
  } else if(a.isMul && a is Mul) {
    Map<Expr, Expr>? terms;
    Expr? termsCoeff;
    final coeffList = <Expr>[];
    for (final ai in a.args) {
      final (ci, ti) = _linEq2Dict(ai, symset);
      if(ti.isEmpty) {
        coeffList.add(ci);
      } else if(terms == null) {
        terms = ti;
        termsCoeff = ci;
      } else {
        // since ti is not null and we already have
        // aa term, this is a cross term
        throw PolyNonlinearException('nonlinear cross-term: $a');
      }
    }
    final coeff = Mul(coeffList);
    if(terms == null) {
      return (coeff, {});
    } else {
      terms = terms.map((sym, c) => MapEntry(sym, coeff * c));
      return (coeff * termsCoeff, terms);
    }
  } else if(!a.hasXFree(symset)) {
    return (a, {});
  } else {
    throw PolyNonlinearException('nonlinear term: $a');
  }
}
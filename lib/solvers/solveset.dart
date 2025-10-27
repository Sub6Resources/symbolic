import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/expr.dart';
import 'package:symbolic/core/numbers.dart' show Zero;
import 'package:symbolic/polys/matrices/linsolve.dart';
import 'package:symbolic/polys/solvers.dart';

class NonlinearException implements Exception {
  final String message;

  NonlinearException(this.message);
}


// ###############################################################################
// ################################ LINSOLVE #####################################
// ###############################################################################

List<Expr> linearCoeffs(Basic<dynamic> eq, List<Expr> syms) {
  final symset = syms.toSet();
  if(symset.length != syms.length) {
    throw ArgumentError("Duplicate symbols given");
  }
  try {
    var (dList, cList) = linearEqToDict([eq], symset.toList());
    final d = dList[0];
    final c = cList[0];

    final rv = <Expr>[
      for(var i=0; i < syms.length + 1; i++)
        Zero.instance,
    ];
    rv[rv.length - 1] = c;
    for(var i = 0; i < syms.length; i++) {
      if(!d.containsKey(syms[i])) {
        continue;
      }
      rv[i] = d[syms[i]]!;
    }
    return rv;
  } on PolyNonlinearException catch(e) {
    throw NonlinearException(e.toString());
  }
}
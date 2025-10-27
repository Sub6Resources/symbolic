import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/mul.dart';
import 'package:symbolic/core/power.dart';

/// Return [expr] with arguments of multiple [Abs] in a term collected
/// under a single instance.
T collectAbs<T extends Basic<T>>(T expr) {
  throw UnimplementedError("collectAbs not yet implemented in radsimp.dart");
  // return expr
  //     .replace(
  //       (x) => x is Mul,
  //       (x) => _abs(x),
  //     ).replace(
  //       (x) => x is Pow,
  //       (x) => _abs(x),
  //     );
}
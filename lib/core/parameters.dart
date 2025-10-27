sealed class GlobalParameters {
  /// Control automatic evaluation
  ///
  /// Explanation
  /// ==========-
  /// This parameter controls whether or not all symbolic functions evaluate
  /// by default.
  ///
  /// Note that much of symbolic expects evaluated expressions. This functionality
  /// is experimental and is unlikely to function as intended on large
  /// expressions.
  ///
  /// Examples
  /// ========
  /// ```dart
  /// print(x + x);  // "2*x"
  /// GlobalParameters.evaluate = false;
  /// print(x + x);  // "x + x"
  /// ```
  static bool evaluate = true;

  /// Control automatic distribution of Number over Add
  ///
  /// Explanation
  /// ===========
  /// This parameter controls whether or not Mul distributes Number over
  /// Add. Plan is to avoid distributing Number over Add in all of symbolic. Once
  /// that is done, this parameter will be removed.
  ///
  /// Examples
  /// ========
  /// ```dart
  /// print(2*(x + 1)); // "2*x + 2"
  /// GlobalParameters.distribute = false;
  /// print(2*(x + 1)); // "2*(x + 1)"
  /// ```
  static bool distribute = true;

  /// Control whether `e^x` should be represented as `exp(x)` or `Pow(E, x)`
  ///
  /// Examples
  /// ========
  /// ```dart
  /// GlobalParameters.expIsPow = true;
  /// print(exp(x).runtimeType); // "Pow"
  /// GlobalParameters.expIsPow = false;
  /// print(exp(x).runtimeType); // "exp"
  /// ```
  static bool expIsPow = false;
}
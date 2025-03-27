import 'package:symbolic/core/basic.dart';

/// Generic printer
///
/// Its job is to provide infrastructure for implementing new printers easily.
///
/// If you want to define your custom Printer or your custom printing method
/// for your custom class then see the example above: [printer_example_].
abstract class Printer<I extends Printerface> {
  Map<String, dynamic> _context;
  int _printLevel;



  Printer(): _printLevel = 0, _context = {};  // mutable during printing


  String doPrint(Basic expr) {
    return print(expr);
  }

  /// Internal dispatcher
  ///
  /// Tries the following concepts to print an expression:
  ///     1. Let the object print itself if it knows how.
  ///     2. Take the best fitting method defined in the printer.
  ///     3. As fall-back use the emptyPrinter method for the printer.
  String print(Basic expr) {
    _printLevel++;

    try {
      // 1. Let the object print itself
      if(expr is I) {
        return (expr as I).print();
      }

      try {
        // 2. Print supported objects
        final result = printObject(expr);
        return result;
      } on NoPrinterAvailable {
        // Unknown object, fall back to the emptyPrinter.
        return emptyPrinter(expr);
      }
    } finally {
      _printLevel--;
    }
  }

  String printObject(Object expr);

  String emptyPrinter(Basic expr) {
    return expr.toString();
  }
}

abstract class Printerface {
  String print();
}

/// Exception thrown when no printer is available for the given object.
class NoPrinterAvailable implements Exception {}

extension on Map<String, dynamic> {
  /// Returns a shallow copy of this Map.
  Map<String, dynamic> copy() {
    final copy = <String, dynamic>{};
    for(final entry in entries) {
      copy[entry.key] = entry.value;
    }
    return copy;
  }
}
import 'package:symbolic/core/basic.dart';
import 'package:symbolic/core/relational.dart';
import 'package:symbolic/core/symbol.dart';
import 'package:symbolic/printing/conventions.dart';
import 'package:symbolic/printing/printer.dart';

class LatexPrinterSettings {
  /// What to use for the adjoint symbol. Defined options are [dagger]
  /// (default), [star]. and [hermitian].
  final AdjointStyle adjointStyle;

  /// Specifies what separator to use to separate the whole and fractional parts of aa
  /// floating point number as in `2.5` for the default, [period] or `2{,}5`
  /// when [comma] is specified. Lists, sets, and tuples are printed with semicolon
  /// separating the elements when [comma] is chosen. For example, `[1; 2; 3]` and
  /// a comma when [period] is chosen. For example, `[1,2,3]`.
  final DecimalSeparator decimalSeparator;

  /// Style to use for the differential operator. Default is [d], to print in italic
  /// form. [rd], [td] are shortcuts for `\mathrm{d}` and `\text{d}` respectively.
  final DiffOperator diffOperator;

  /// If set to true, a floating point number is printed with full precision.
  final bool fullPrec;

  /// Emit `^{p/q}` instead of `^{\frac{p}{q}}` for fractional powers.
  final bool foldFracPowers;

  /// Fold function brackets where applicable.
  final bool foldFuncBrackets;

  /// Emit `^{p/q}` instead of `^{\frac{p}{q}}` when the denominator is
  /// simple enough (at most two terms and no powers). The default value is
  /// true for inline mode, false otherwise.
  final bool? foldShortFrac;

  /// If set to true, `\Re` and `\Im` are used for `re` and `im`, respectively.
  /// The default is false leading to `\operatorname{re}` and `\operatorname{im}`.
  final bool gothicReIm;

  /// How inverse trig functions should be displayed. Can be one of
  /// [abbreviated], [full], or [power]. Defaults to [abbreviated].
  final InvTrigStyle invTrigStyle;

  /// What to use for the imaginary unit. Defined options are [i]
  /// (default) and [j]. Adding `r` or `t` in front gives `\mathrm`
  /// or `\text`. For example, [ri] leads to `\mathrm{i}`.
  final ImaginaryUnit imaginaryUnit;

  /// Specifies if itex-specific syntax is used, including emitting `$$...$$`.
  final bool itex;

  /// If set to true, `\ln` is used instead of the default `\log`.
  final bool lnNotation;

  /// The allowed ratio of the width of the numerator to the width of the
  /// denominator before the printer breaks off long fractions. If `null`
  /// (the default value), long fractions are not broken up.
  final double? longFracRatio;

  /// The delimiter to wrap around matrices. Can be one of [brackets],
  /// [parentheses], or [none]. Defaults to [brackets]
  final MatrixDelimiter matDelim;

  /// Which matrix environment string to emit. `smallmatrix`,
  /// `matrix`, `array`, etc. Defaults to `smallmatrix` for
  /// inline mode, `matrix` for matrices of no more than 10 columns, and
  /// `array` otherwise.
  final String? matStr;

  /// Can be either [plain] (default) or [bold]. If set to
  /// [bold], a [MatrixSymbol] A will be printed as `\mathbf{A}`,
  /// otherwise as `A`.
  final SymbolStyle matSymbolStyle;

  /// Sets the upper bound for the exponent to print floating point numbers in
  /// fixed-point format.
  final int? max;

  /// Sets the lower bound for the exponent to print floating point numbers in
  /// fixed-point format.
  final int? min;

  /// Specifies how the generated code will be delimited. `mode` can be one
  /// of [plain], [inline], [equation] or [equationStar].  If
  /// `mode` is set to [plain], then the resulting code will not be
  /// delimited at all (this is the default). If `mode` is set to
  /// [inline] then inline LaTeX `$...$` will be used. If `mode` is
  /// set to [equation] or [equationStar], the resulting code will be
  /// enclosed in the `equation` or `equation*` environment (remember to
  /// import `amsmath` for `equation*`), unless the `itex` option is
  /// set. In the latter case, the `$$...$$` syntax is used.
  final LatexPrintingMode mode;

  /// The symbol used for multiplication. Can be one of [none],
  /// [ldot], [dot], or [times].
  final MulSymbol mulSymbol;

  /// Any of the supported monomial orderings (currently [lex],
  /// [grlex], [grevlex], and [none]. This
  /// parameter does nothing for [Mul] objects.
  /// for very large expressions, set the `order` to [none] if
  /// speed is a concern.
  final MonomialOrdering order;

  /// IIf set to false, superscripted expressions will not be parenthesized when
  /// powered. Default is true, which parenthesizes the expression when powered.
  final bool parenthesizeSuper;

  /// Whether or not to print permutations in cyclic notation.
  final bool permCyclic;

  /// If set to false, exponents of the form 1/n aare printed in fractional
  /// form. Default is true, to print exponent in root form.
  final bool rootNotation;

  /// Optional [Map] of symbols mapped to custom strings they should
  /// be emitted as.
  final Map<Symbol, String> symbolNames;

  const LatexPrinterSettings({
    this.adjointStyle = AdjointStyle.dagger,
    this.decimalSeparator = DecimalSeparator.period,
    this.diffOperator = DiffOperator.d,
    this.fullPrec = false,
    this.foldFracPowers = false,
    this.foldFuncBrackets = false,
    this.foldShortFrac,
    this.gothicReIm = false,
    this.invTrigStyle = InvTrigStyle.abbreviated,
    this.imaginaryUnit = ImaginaryUnit.i,
    this.itex = false,
    this.lnNotation = false,
    this.longFracRatio,
    this.matDelim = MatrixDelimiter.brackets,
    this.matStr,
    this.matSymbolStyle = SymbolStyle.plain,
    this.max,
    this.min,
    this.mode = LatexPrintingMode.plain,
    this.mulSymbol = MulSymbol.none,
    this.order = MonomialOrdering.none,
    this.parenthesizeSuper = true,
    this.permCyclic = true,
    this.rootNotation = true,
    this.symbolNames = const {},
  });

  LatexPrinterSettings copyWith({
    AdjointStyle? adjointStyle,
    DecimalSeparator? decimalSeparator,
    DiffOperator? diffOperator,
    bool? fullPrec,
    bool? foldFracPowers,
    bool? foldFuncBrackets,
    bool? foldShortFrac,
    bool? gothicReIm,
    InvTrigStyle? invTrigStyle,
    ImaginaryUnit? imaginaryUnit,
    bool? itex,
    bool? lnNotation,
    double? longFracRatio,
    MatrixDelimiter? matDelim,
    String? matStr,
    SymbolStyle? matSymbolStyle,
    int? max,
    int? min,
    LatexPrintingMode? mode,
    MulSymbol? mulSymbol,
    MonomialOrdering? order,
    bool? parenthesizeSuper,
    bool? permCyclic,
    bool? rootNotation,
    Map<Symbol, String>? symbolNames,
  }) {
    return LatexPrinterSettings(
      adjointStyle: adjointStyle ?? this.adjointStyle,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      diffOperator: diffOperator ?? this.diffOperator,
      fullPrec: fullPrec ?? this.fullPrec,
      foldFracPowers: foldFracPowers ?? this.foldFracPowers,
      foldFuncBrackets: foldFuncBrackets ?? this.foldFuncBrackets,
      foldShortFrac: foldShortFrac ?? this.foldShortFrac,
      gothicReIm: gothicReIm ?? this.gothicReIm,
      invTrigStyle: invTrigStyle ?? this.invTrigStyle,
      imaginaryUnit: imaginaryUnit ?? this.imaginaryUnit,
      itex: itex ?? this.itex,
      lnNotation: lnNotation ?? this.lnNotation,
      longFracRatio: longFracRatio ?? this.longFracRatio,
      matDelim: matDelim ?? this.matDelim,
      matStr: matStr ?? this.matStr,
      matSymbolStyle: matSymbolStyle ?? this.matSymbolStyle,
      max: max ?? this.max,
      min: min ?? this.min,
      mode: mode ?? this.mode,
      mulSymbol: mulSymbol ?? this.mulSymbol,
      order: order ?? this.order,
      parenthesizeSuper: parenthesizeSuper ?? this.parenthesizeSuper,
      permCyclic: permCyclic ?? this.permCyclic,
      rootNotation: rootNotation ?? this.rootNotation,
      symbolNames: symbolNames ?? Map<Symbol, String>.from(this.symbolNames),
    );
  }
}

enum AdjointStyle {
  dagger,
  hermitian,
  star;
}

enum DecimalSeparator {
  period(".", ","),
  comma(",", ";");

  final String separator;
  final String listSeparator;

  const DecimalSeparator(this.separator, this.listSeparator);
}

enum DiffOperator {
  d("d"),
  rd("\\mathrm{d}"),
  td("\\text{d}");

  final String latex;
  const DiffOperator(this.latex);
}

enum InvTrigStyle {
  abbreviated,
  full,
  power;
}

enum ImaginaryUnit {
  i("i"),
  j("j"),
  ri("\\mathrm{i}"),
  ti("\\text{i}"),
  rj("\\mathrm{j}"),
  tj("\\text{j}");

  final String latex;

  const ImaginaryUnit(this.latex);
}

enum MatrixDelimiter {
  brackets,
  parentheses,
  none;
}

enum SymbolStyle {
  plain,
  bold;
}

enum LatexPrintingMode {
  plain,
  inline,
  equation,
  equationStar;
}

enum MulSymbol {
  none,
  ldot,
  dot,
  times;
}

enum MonomialOrdering {
  lex,
  grlex,
  grevlex,
  none;
}

class LatexPrinter extends Printer<LatexPrinterface> {

  LatexPrinterSettings settings;

  LatexPrinter({this.settings = const LatexPrinterSettings()}) {
    if(settings.foldShortFrac == null
        && settings.mode == LatexPrintingMode.inline) {
      settings = settings.copyWith(foldShortFrac: true);
    }
  }

  @override
  String doPrint(Basic expr) {
    final tex = super.doPrint(expr);

    return switch(settings.mode) {
      LatexPrintingMode.plain => tex,
      LatexPrintingMode.inline => "\$$tex\$",
      LatexPrintingMode.equation => settings.itex? "\$\$$tex\$\$": "\\begin{equation}$tex\\end{equation}",
      LatexPrintingMode.equationStar => settings.itex? "\$\$$tex\$\$": "\\begin{equation*}$tex\\end{equation*}",
    };
  }

  @override
  String printObject(Object expr) {
    return switch(expr) {
      Relational() => _printRelational(expr),
      Symbol() => _printSymbol(expr),
      Object() => throw NoPrinterAvailable(),
    };
  }

  String _printRelational(Relational expr) {
    String gt = ">";
    String lt = "<";
    if(settings.itex) {
      gt = r"\gt";
      lt = r"\lt";
    }

    final charmap = {
      "==": "=",
      ">": gt,
      "<": lt,
      ">=": r"\geq",
      "<=": r"\leq",
      "!=": r"\neq",
    };

    return "${this.print(expr.lhs)} ${charmap[expr.relOp]!} ${this.print(expr.rhs)}";
  }

  String _printSymbol(Symbol expr, {SymbolStyle style = SymbolStyle.plain}) {
    final name = settings.symbolNames[expr];
    if(name != null) {
      return name;
    }

    return _dealWithSuperSub(expr.name, style: style);
  }

  String _dealWithSuperSub(String string, {SymbolStyle style = SymbolStyle.plain}) {
    String name;
    List<String> supers;
    List<String> subs;
    if(string.contains("{")) {
      (name, supers, subs) = (string, [], []);
    } else {
      (name, supers, subs) = splitSuperSub(string);

      name = translate(name);
      supers = [for(final sup in supers) translate(sup)];
      subs = [for(final sub in subs) translate(sub)];
    }

    if(style == SymbolStyle.bold) {
      name = "\\mathbf{$name}";
    }

    if(supers.isNotEmpty) {
      name += "^{${supers.join(" ")}}";
    }
    if(subs.isNotEmpty) {
      name += "_{${subs.join(" ")}}";
    }

    return name;
  }

  @override
  String emptyPrinter(Basic expr) {
    final s = super.emptyPrinter(expr);

    return "\\mathtt{\\text{${latexEscape(s)}}}";
  }
}

/// Escape a string such that latex interprets it as plaintext.
///
/// We cannot use verbatim easily with mathjax, so escaping is easier.
/// Rules from https://tex.stackexchange.com/a/34586/41112.
String latexEscape(String s) {
  s = s.replaceAll(r'\', r'\textbackslash');
  for(final c in r"&%$#_{}".split("")) {
    s = s.replaceAll(c, "\\$c");
  }
  s = s.replaceAll("~", r"\textasciitilde");
  s = s.replaceAll("^", r"\textasciicircum");
  return s;
}

abstract interface class LatexPrinterface extends Printerface {}

String translate(String s) {
  // TODO add full implementation
  return s;
}
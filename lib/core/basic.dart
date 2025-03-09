class Basic {
  Basic(this.args);

  List<Basic> args;

  Set<Basic> freeSymbols() {
    return args.fold(<Basic>{}, (Set<Basic> acc, Basic arg) {
      acc.addAll(arg.freeSymbols());
      return acc;
    });
  }

  Basic subs(Object substitutions, [bool simultaneous = false]) {
    throw UnimplementedError();
    // TODO: implement
    // if(substitutions is (Object, Object)) {
    //   return this;
    // }
    // if(substitutions is Map) {
    //   return this;
    // }
    // if(substitutions is List) {
    //   return this;
    // }
    //
    // return this;
  }
}
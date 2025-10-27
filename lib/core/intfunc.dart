/// Computes nonnegative integer greatest common divisor.
BigInt igcd(List<BigInt> args) {
  assert(args.length >= 2,
      "igcd() takes at least 2 arguments (${args.length} given)");
  return args.reduce((a, b) => a.gcd(b));
}

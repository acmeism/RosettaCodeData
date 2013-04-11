use Math::BigInt;

sub gcd($$) {
  Math::BigInt::bgcd(@_)->numify();
}

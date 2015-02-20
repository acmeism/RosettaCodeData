use ntheory qw/is_strong_pseudoprime miller_rabin_random/;
sub is_prime_mr {
  my $n = shift;
  # If 32-bit, we can do this with 3 bases.
  return is_strong_pseudoprime($n, 2, 7, 61) if ($n >> 32) == 0;
  # If 64-bit, 7 is all we need.
  return is_strong_pseudoprime($n, 2, 325, 9375, 28178, 450775, 9780504, 1795265022) if ($n >> 64) == 0;
  # Otherwise, perform a number of random base tests, and the result is a probable prime test.
  return miller_rabin_random($n, 20);
}

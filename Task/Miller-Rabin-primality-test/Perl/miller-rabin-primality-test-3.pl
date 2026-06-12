use Math::Primality qw/is_strong_pseudoprime/;
sub is_prime_mr {
  my $n = shift;
  return 0 if $n < 2;
  for (2,3,5,7,11,13,17,19,23,29,31,37) {
    return 0 unless $n <= $_ || is_strong_pseudoprime($n,$_);
  }
  1;
}
for (1..100) { say if is_prime_mr($_) }

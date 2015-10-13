use ntheory qw/forprimes is_mersenne_prime/;
use Math::GMP qw/:constant/;
forprimes {
  print "$_\t", (2**$_-1)*2**($_-1),"\n"  if is_mersenne_prime($_);
} 7_000_000;

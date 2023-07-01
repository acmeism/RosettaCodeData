use ntheory qw/forprimes is_prime/;
use bigint;
forprimes {
  my $n = 2**$_ - 1;
  print "$_\t", $n * 2**($_-1),"\n"   if is_prime($n);
} 2, 4500;

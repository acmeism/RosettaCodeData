use strict;
use warnings;
# Select one of these lines.  Math::BigInt is in core, but quite slow.
use Math::BigInt;  sub binomial { Math::BigInt->new(shift)->bnok(shift) }
# use Math::Pari "binomial";
# use ntheory "binomial";

sub binprime {
  my $p = shift;
  return 0 unless $p >= 2;
  # binomial is symmetric, so only test half the terms
  for (1 .. ($p>>1)) { return 0 if binomial($p,$_) % $p }
  1;
}
sub coef {                   # For prettier printing
  my($n,$e) = @_;
  return $n unless $e;
  $n = "" if $n==1;
  $e==1 ? "${n}x" : "${n}x^$e";
}
sub binpoly {
  my $p = shift;
  join(" ", coef(1,$p),
            map { join("",("+","-")[($p-$_)&1]," ",coef(binomial($p,$_),$_)) }
            reverse 0..$p-1 );
}
print "expansions of (x-1)^p:\n";
print binpoly($_),"\n" for 0..9;
print "Primes to 80: [", join(",", grep { binprime($_) } 2..80), "]\n";

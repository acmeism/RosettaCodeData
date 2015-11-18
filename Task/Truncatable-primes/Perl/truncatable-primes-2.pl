use ntheory ":all";

my @lprimes = my @rprimes = (2,3,5,7);

@lprimes = sort { $a <=> $b }
           map { my $p=$_; map { is_prime($_.$p) ? $_.$p : () } 1..9 } @lprimes
  for 2..6;

@rprimes = sort { $a <=> $b }
           map { my $p=$_; map { is_prime($p.$_) ? $p.$_ : () } 1..9 } @rprimes
  for 2..6;

print "ltrunc: $lprimes[-1]\nrtrunc: $rprimes[-1]\n";

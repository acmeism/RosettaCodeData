use utf8;
binmode STDOUT, ":utf8";

sub gcd {
  my ($u, $v) = @_;
  while ($v) {
    ($u, $v) = ($v, $u % $v);
  }
  return abs($u);
}

push @𝜑, 0;
for $t (1..10000) {
    push @𝜑, scalar grep { 1 == gcd($_,$t) } 1..$t;
}

printf "𝜑(%2d) = %3d%s\n", $_, $𝜑[$_], $_ - $𝜑[$_] - 1 ? '' : ' Prime' for 1 .. 25;
print "\n";

for $limit (100, 1000, 10000) {
    printf "Count of primes <= $limit: %d\n", scalar grep {$_ == $𝜑[$_] + 1} 0..$limit;
}

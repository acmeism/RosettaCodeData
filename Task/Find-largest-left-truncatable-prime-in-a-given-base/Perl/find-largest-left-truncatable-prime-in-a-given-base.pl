use ntheory qw/:all/;
use Math::GMPz;

sub lltp {
  my($n, $b, $best) = (shift, Math::GMPz->new(1));
  my @v = map { Math::GMPz->new($_) } @{primes($n-1)};
  while (@v) {
    $best = vecmax(@v);
    $b *= $n;
    my @u;
    foreach my $vi (@v) {
      push @u, grep { is_prob_prime($_) } map { $vi + $_*$b } 1 .. $n-1;
    }
    @v = @u;
  }
  die unless is_provable_prime($best);
  $best;
}

printf "%2d %s\n", $_, lltp($_)  for 3 .. 17;

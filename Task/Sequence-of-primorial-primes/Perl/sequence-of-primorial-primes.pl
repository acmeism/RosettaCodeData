use ntheory ":all";
my $i = 0;
for (1..1e6) {
  my $n = pn_primorial($_);
  if (is_prime($n-1) || is_prime($n+1)) {
    print "$_\n";
    last if ++$i >= 20;
  }
}

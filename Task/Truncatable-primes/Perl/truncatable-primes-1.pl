use ntheory ":all";
sub isltrunc {
  my $n = shift;
  return (is_prime($n) && $n !~ /0/ && ($n < 10 || isltrunc(substr($n,1))));
}
sub isrtrunc {
  my $n = shift;
  return (is_prime($n) && $n !~ /0/ && ($n < 10 || isrtrunc(substr($n,0,-1))));
}
for (reverse @{primes(1e6)}) {
  if (isltrunc($_)) { print "ltrunc: $_\n"; last; }
}
for (reverse @{primes(1e6)}) {
  if (isrtrunc($_)) { print "rtrunc: $_\n"; last; }
}

sub isprime {
  my $n = shift;
  return ($n >= 2) if $n < 4;
  return unless $n % 2  &&  $n % 3;
  my $sqrtn = int(sqrt($n));
  for (my $i = 5; $i <= $sqrtn; $i += 6) {
    return unless $n % $i && $n % ($i+2);
  }
  1;
}
my $s = 0;
$s += !!isprime($_) for 1..100000;
print "Pi(100,000) = $s\n";

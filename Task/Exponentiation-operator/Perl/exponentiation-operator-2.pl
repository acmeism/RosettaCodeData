sub ex {
  my($base,$exp) = @_;
  die "Exponent '$exp' must be an integer!" if $exp != int($exp);
  return 1 if $exp == 0;
  ($base, $exp) = (1/$base, -$exp)  if $exp < 0;
  my $c = 1;
  while ($exp > 1) {
    $c *= $base if $exp % 2;
    $base *= $base;
    $exp >>= 1;
  }
  $base * $c;
}

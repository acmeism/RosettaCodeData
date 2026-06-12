sub msb {
  my ($n, $base) = (shift, 0);
  $base++ while $n >>= 1;
  $base;
}
sub lsb {
  my $n = shift;
  msb($n & -$n);
}

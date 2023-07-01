sub gcd_bin($$) {
  my ($u, $v) = @_;
  $u = abs($u);
  $v = abs($v);
  if ($u < $v) {
    ($u, $v) = ($v, $u);
  }
  if ($v == 0) {
    return $u;
  }
  my $k = 1;
  while ($u & 1 == 0 && $v & 1 == 0) {
    $u >>= 1;
    $v >>= 1;
    $k <<= 1;
  }
  my $t = ($u & 1) ? -$v : $u;
  while ($t) {
    while ($t & 1 == 0) {
      $t >>= 1;
    }
    if ($t > 0) {
      $u = $t;
    } else {
      $v = -$t;
    }
    $t = $u - $v;
  }
  return $u * $k;
}

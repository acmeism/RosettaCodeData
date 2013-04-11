sub gcd($$) {
  my ($u, $v) = @_;
  if ($v) {
    return gcd($v, $u % $v);
  } else {
    return abs($u);
  }
}

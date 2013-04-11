use 5.10.0;

sub ng {
  state %g;
  my ($n, $d, $key) = ( @_[0], @_[1], $n.'ng'.$d);
  if (!$g{$key}) {$g[$key] = ($n <= $d+1)? $n : ng($n-$d,$d)*$n}
  return $g[$key];
}

use v5.36;
use experimental 'for_list';

sub F1($n, $x, $y) { $n ? $y ? F1($n-1, F2($n,$x,$y-1), F3($n,$x,$y-1)+$y) : $x : $x+$y }

sub F2($n, $x, $y) { $n == 0 ? $x+$y : $y == 0 ? $x : F2($n-1, F1($n,$x,$y-1), F3($n,$x,$y-1)+$y) }

sub F3($n, $x, $y) {
  return $x + $y if $n == 0;
  return $x      if $y == 0;
  F3($n-1, F1($n, $x, $y-1), F2($n, $x, $y-1) + $y)
}

for my($n,$x,$y) (0,0,0, 1,1,1, 2,1,1, 3,1,1, 2,2,1) {
    say join ' ',F1($n,$x,$y), F2($n,$x,$y), F3($n,$x,$y)
}

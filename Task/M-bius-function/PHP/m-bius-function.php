<?php
// Moebius function

function moebius($n) {
  $m = 1;
  if ($n != 1) {
    $f = 2;
    do {
      if ($n % ($f * $f) == 0) {
        $m = 0;
      } else {
        if ($n % $f == 0) {
          $m = -$m;
          $n /= $f;
        }
        $f++;
      }
    } while ($f <= $n && $m != 0);
  }
  return $m;
}

for ($t = 0; $t <= 9; $t++) {
  for ($u = 1; $u <= 10; $u++) {
    echo str_pad(moebius(10 * $t + $u), 2, " ", STR_PAD_LEFT)."  ";
  }
  echo PHP_EOL;
}
?>

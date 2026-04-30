<?php
// Prime decomposition

const MAX_FAC_INDEX = 30; // -(2^31) has most prime factors (31 twos) than other 32-bit signed integer.
$facs = array_fill(0, MAX_FAC_INDEX + 1, 0);
test(2);
test(2520);
test(13);

function test($n) {
  echo $n.' => ';
  $cnt = facs_cnt($n, $facs);
  for ($i = 0; $i <= $cnt - 2; $i++)
    echo $facs[$i].' ';
  echo $facs[$cnt - 1].PHP_EOL;
}

function facs_cnt(int $n, &$facs): int {
  $n = abs($n);
  $cnt = 0;
  if ($n >= 2) {
    $i = 2;
    while ($i * $i <= $n) {
      if ($n % $i == 0) {
        $n = intdiv($n, $i);
        $facs[$cnt] = $i;
        $cnt++;
        $i = 2;
      }
      else {
        $i++;
      }
    }
    $facs[$cnt] = $n;
    $cnt++;
  }
  return $cnt;
}
?>

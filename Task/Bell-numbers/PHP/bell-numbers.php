<?php
// Bell numbers
const MAX_N = 14;
$a = array_fill(0, MAX_N - 1, 0);
$n = 0;
$a[0] = 1;
echo 'B('.str_pad($n, 2, " ", STR_PAD_LEFT).') = '.
    str_pad($a[0], 9, " ", STR_PAD_LEFT).PHP_EOL;
while ($n < MAX_N) {
  $a[$n] = $a[0];
  for ($j = $n; $j >= 1; $j--)
    $a[$j - 1] += $a[$j];
  $n++;
  echo 'B('.str_pad($n, 2, " ", STR_PAD_LEFT).') = '.
      str_pad($a[0], 9, " ", STR_PAD_LEFT).PHP_EOL;
}
?>

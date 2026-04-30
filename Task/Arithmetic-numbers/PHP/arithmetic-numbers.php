<?php
// Arithmetic numbers
$n = 1;
$arithm_cnt = 0;
$comp_cnt = 0;
echo 'The first 100 arithmetic numbers are:'.PHP_EOL;
while ($arithm_cnt < 1000001) {
  $dv = 1;
  $dv_cnt = 0;
  $sum = 0;
  while (true) {
    $quot = intdiv($n, $dv);
    if ($quot < $dv)
      break;
    if ($quot == $dv && $n % $dv == 0) {
      // $n is a square
      $sum += $quot;
      $dv_cnt++;
      break;
    }
    if ($n % $dv == 0) {
      $sum += $dv + $quot;
      $dv_cnt += 2;
    }
    $dv++;
  }
  if ($sum % $dv_cnt == 0) {
    // $n is arithmetic
    $arithm_cnt++;
    if ($arithm_cnt <= 100) {
      echo str_pad($n, 4, ' ', STR_PAD_LEFT);
      if ($arithm_cnt % 10 == 0)
        echo PHP_EOL;
    }
    if ($dv_cnt > 2)
      $comp_cnt++;
    if ($arithm_cnt == 1000 || $arithm_cnt == 10000 ||
        $arithm_cnt == 100000 || $arithm_cnt == 1000000) {
      echo PHP_EOL;
      echo 'The '.str_pad($arithm_cnt, 7, ' ', STR_PAD_LEFT).
          'th arithmetic number is '.
          str_pad($n, 8, ' ', STR_PAD_LEFT) .
          ' up to which ', str_pad($comp_cnt, 6, ' ', STR_PAD_LEFT).
          ' are composite.';
    }
  }
  $n++;
}
echo PHP_EOL;
?>

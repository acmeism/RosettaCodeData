<?php
// Abundant odd numbers

function divisor_sum(int $n) {
  $sum = 1;
  $sqrt_n = sqrt($n);
  for ($d = 2; $d <= $sqrt_n; $d++)
    if ($n % $d == 0) {
      $sum += $d;
      $other_d = intdiv($n, $d);
      if ($other_d != $d)
        $sum += $other_d;
    }
  return $sum;
}

// first 25 odd abundant numbers
$odd_number = 1;
$a_count = 0;
$d_sum = 0;
echo 'The first 25 abundant odd numbers:'.PHP_EOL;
while ($a_count < 25) {
  $d_sum = divisor_sum($odd_number);
  if ($d_sum > $odd_number) {
    $a_count++;
    echo str_pad($odd_number, 6, " ", STR_PAD_LEFT).
      ' proper divisor sum: '.
      str_pad($d_sum, 6, " ", STR_PAD_LEFT).PHP_EOL;
  }
  $odd_number += 2;
}
// 1000th odd abundant number
while ($a_count < 1000) {
  $d_sum = divisor_sum($odd_number);
  if ($d_sum > $odd_number)
    $a_count++;
  $odd_number += 2;
}
echo '1000th abundant odd number:'.PHP_EOL;
echo '    '.($odd_number - 2).' proper divisor sum: '.$d_sum.PHP_EOL;
// first odd abundant number > 1000000000
$odd_number = 1000000001;
$found = false;
while (!$found) {
  $d_sum = divisor_sum($odd_number);
  if ($d_sum > $odd_number) {
    $found = true;
    echo 'First abundant odd number > 1 000 000 000:'.PHP_EOL;
    echo '    '.$odd_number.' proper divisor sum: '.$d_sum.PHP_EOL;
  }
  $odd_number += 2;
}
?>

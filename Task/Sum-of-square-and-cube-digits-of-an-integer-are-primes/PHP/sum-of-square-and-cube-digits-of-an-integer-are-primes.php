<?php
// Editing Sum of square and cube digits of an integer are primes

function is_prime(int $num): bool {
  if ($num < 2) {
    return false;
  }
  if ($num == 2) {
    return true;
  }
  if ($num % 2 == 0) {
    return false;
  }
  for ($i = 3; $i * $i <= $num; $i += 2) {
    if ($num % $i == 0) {
      return false;
    }
  }
  return true;
}

function sum_digits(int $num): int {
  $sum = 0;
  while ($num != 0) {
    $sum += $num % 10;
    $num = intdiv($num, 10);
  }
  return $sum;
}

for ($n = 0; $n <= 99; $n++) {
  if (is_prime(sum_digits($n * $n)) && is_prime(sum_digits($n * $n * $n))) {
    echo $n . ' ';
  }
}
echo PHP_EOL;
?>

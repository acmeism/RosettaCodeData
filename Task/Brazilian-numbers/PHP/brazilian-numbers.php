<?php
// Brazilian numbers

function same_digits(int $n, int $b): bool {
  // Result: true if $n has same digits in the base $b, false otherwise
  $n_tmp = $n;
  $f = $n_tmp % $b;
  $n_tmp = intdiv($n_tmp, $b);
  while ($n_tmp > 0) {
    if ($n_tmp % $b != $f)
      return false;
    $n_tmp = intdiv($n_tmp, $b);
  }
  return true;
}

function is_brazilian(int $n): bool {
  if ($n < 7)
    return false;
  else if ($n % 2 == 0 && $n >= 8)
    return true;
  else {
    for ($b = 2; $b <= $n - 2; $b++)
      if (same_digits($n, $b))
        return true;
    return false;
  }
}

function is_prime(int $n): bool {
  if ($n < 2)
    return false;
  else if ($n % 2 == 0)
    return ($n == 2);
  else if ($n % 3 == 0)
    return ($n == 3);
  else {
    $d = 5;
    while ($d * $d <= $n) {
      if ($n % $d == 0)
        return false;
      else {
        $d +=  2;
        if ($n % $d == 0)
          return false;
        else
          $d += 4;
      }
    }
    return true;
  }
}

echo 'First 20 Brazilian numbers:'.PHP_EOL;
$c = 0;
$n = 7;
while ($c < 20) {
  if (is_brazilian($n)) {
    echo $n.' ';
    $c++;
  }
  $n++;
}
echo PHP_EOL.PHP_EOL.'First 20 odd Brazilian numbers:'.PHP_EOL;
$c = 0;
$n = 7;
while ($c < 20) {
  if (is_brazilian($n)) {
    echo $n.' ';
    $c++;
  }
  $n += 2;
}
echo PHP_EOL.PHP_EOL.'First 20 prime Brazilian numbers:'.PHP_EOL;
$c = 0;
$n = 7;
while ($c < 20) {
  if (is_brazilian($n)) {
    echo $n.' ';
    $c++;
  }
  do
    $n += 2;
  while (!is_prime($n));
}
echo PHP_EOL;
?>

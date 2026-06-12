<?php
// De Polignac numbers
const MAX_NUMBER = 500000;
const MAX_POWER = 20;
$powers_of_2 = array_fill(0, MAX_POWER + 1, 0);
$prime = array_fill(0, MAX_NUMBER + 1, false);
// Sieve the primes to MAX_NUMBER
$prime[2] = true;
for ($i = 3; $i <= MAX_NUMBER; $i += 2)
  $prime[$i] = true;
for ($i = 4; $i <= MAX_NUMBER; $i += 2)
  $prime[$i] = false;
$sqrt_max_number = sqrt(MAX_NUMBER);
for ($i = 3; $i <= $sqrt_max_number; $i += 2) {
  if ($prime[$i]) {
    $s = $i * $i;
    $dbl_i = $i + $i;
    while ($s <= MAX_NUMBER) {
      $prime[$s] = false;
      $s += $dbl_i;
    }
  }
}
// Table of powers of 2
$p2 = 1;
for ($i = 1; $i <= MAX_POWER; $i++) {
  $p2 *= 2;
  $powers_of_2[$i] = $p2;
}
// $n = 0, $p = 2
$dp_count = 1;
echo str_pad(1, 5, " ", STR_PAD_LEFT); // Or literal "    1" if you wish
// $n > 0, $p > 2
for ($i = 5; $i <= MAX_NUMBER; $i += 2) {
  $found = false;
  $p = 1;
  while ($p <= MAX_POWER && !$found && $i > $powers_of_2[$p]) {
    $found = $prime[$i - $powers_of_2[$p]];
    $p++;
  }
  if (!$found) {
    $dp_count++;
    if ($dp_count <= 50) {
      echo str_pad($i, 5, " ", STR_PAD_LEFT);
      if ($dp_count % 10 == 0)
        echo PHP_EOL;
    }
    else if ($dp_count == 1000 || $dp_count == 10000)
      echo 'The '.str_pad($dp_count, 5, " ", STR_PAD_LEFT).
        'th de Polignac number is '.
        str_pad($i, 7, " ", STR_PAD_LEFT).PHP_EOL;
  }
}
echo 'Found '.$dp_count.' de Polignac numbers up to '.MAX_NUMBER.PHP_EOL;
?>

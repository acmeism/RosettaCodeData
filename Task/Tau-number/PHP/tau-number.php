<?php
// Tau number

// return the Tau (number of divisors) of $n
function tau(int $n): int {
  if ($n < 3) {
    $t = $n;
  } else {
    $t = 2;
    $limit = intdiv($n + 1, 2);
    for ($i = 2; $i <= $limit; $i++)
      if ($n % $i == 0)
        $t++;
  }
  return $t;
}

echo 'First 100 Tau numbers:'.PHP_EOL;
$c = 0;
$i = 1;
while ($c < 100) {
  if ($i % tau($i) == 0) {
    echo str_pad($i, 5, ' ', STR_PAD_LEFT);
    $c++;
    if ($c % 10 == 0)
      echo PHP_EOL;
  }
  $i++;
}
echo PHP_EOL;
?>

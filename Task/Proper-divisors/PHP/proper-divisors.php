<?php
function ProperDivisors($n) {
  yield 1;
  $large_divisors = [];
  for ($i = 2; $i <= sqrt($n); $i++) {
    if ($n % $i == 0) {
      yield $i;
      if ($i*$i != $n) {
        $large_divisors[] = $n / $i;
      }
    }
  }
  foreach (array_reverse($large_divisors) as $i) {
    yield $i;
  }
}

assert([1, 2, 4, 5, 10, 20, 25, 50] ==
        iterator_to_array(ProperDivisors(100)));

foreach (range(1, 10) as $n) {
  echo "$n =>";
  foreach (ProperDivisors($n) as $divisor) {
    echo " $divisor";
  }
  echo "\n";
}

$divisorsCount = [];
for ($i = 1; $i < 20000; $i++) {
  $divisorsCount[sizeof(iterator_to_array(ProperDivisors($i)))][] = $i;
}
ksort($divisorsCount);

echo "Numbers with most divisors: ", implode(", ", end($divisorsCount)), ".\n";
echo "They have ", key($divisorsCount), " divisors.\n";

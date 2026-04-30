<?php
// Multifactorial
for ($degree = 1; $degree <= 5; $degree++) {
  echo 'Degree '.$degree.' => ';
  for ($n = 1; $n <= 10; $n++)
    echo multifactorial($n, $degree).' ';
  echo PHP_EOL;
}

function multifactorial (int $n, int $degree): int {
  if ($n < 2)
    return 1;
  else {
    $result = $n;
    for ($i = $n - $degree; $i >= 2; $i -= $degree)
      $result = $result * $i;
    return $result;
  }
}
?>

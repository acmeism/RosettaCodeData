<?php
  function isPrime ($x) {
    if ($x < 2) return false;
    if ($x < 4) return true;
    if ($x % 2 == 0) return false;
    for ($d = 3; $d < sqrt($x); $d++) {
      if ($x % $d == 0) return false;
    }
    return true;
  }

  function countFacs ($n) {
    $count = 0;
    $divisor = 1;
    if ($n < 2) return 0;
    while (!isPrime($n)) {
      while (!isPrime($divisor)) $divisor++;
      while ($n % $divisor == 0) {
        $n /= $divisor;
        $count++;
      }
      $divisor++;
      if ($n == 1) return $count;
    }
  return $count + 1;
  }

  for ($i = 1; $i <= 120; $i++) {
    if (isPrime(countFacs($i))) echo $i."&ensp;";
  }
?>

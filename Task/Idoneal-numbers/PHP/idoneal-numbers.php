<?php
function is_idoneal(int $n): bool {
  // Return 'true' if $n is an Idoneal number
  for ($a = 1; $a <= $n; $a++) {
    for ($b = $a + 1; $b <= $n; $b++) {
      $ab = $a * $b;
      $s = $a + $b;
      if ($ab + $s > $n)
        break;
      else
        for ($c = $b + 1; $c <= $n; $c++) {
          $t = $ab + $c * $s;
          if ($t == $n)
            return false;
          if ($t > $n)
            break;
       }
    }
  }
  return true;
}

$n = 1;
$c = 0;
do {
  if (is_idoneal($n)) {
    echo str_pad($n, 5, ' ', STR_PAD_LEFT);
    $c++;
    if ($c % 13 == 0)
      echo PHP_EOL;
  }
  $n++;
} while ($c < 65);
?>

<?php
// AKS test for primes

const PAS_TRI_MAX = 61;

function vz($b) {
  return ($b ? "-" : "+");
}

function expand_poly($n) {
  if ($n > PAS_TRI_MAX) {
    echo $n, " is out of range", PHP_EOL;
    exit;
  }
  switch ($n) {
    case 0:
      echo "(x-1)^0 = 1", PHP_EOL;
      break;
    case 1:
      echo "(x-1)^1 = x-1", PHP_EOL;
      break;
    default:
      $pas_tri = [];
      pascal_triangle($n, $pas_tri);
      echo "(x-1)^", $n, " = x^", $n;
      $bvz = true;
      $n_div_2 = intdiv($n, 2);
      for ($j = $n - 1; $j > $n_div_2; $j--) {
        echo vz($bvz), $pas_tri[$n - $j], "*x^", $j;
        $bvz = !$bvz;
      }
      for ($j = $n_div_2; $j >= 2; $j--) {
        echo vz($bvz), $pas_tri[$j], "*x^", $j;
        $bvz = !$bvz;
      }
      echo vz($bvz), $pas_tri[1], "*x";
      $bvz = !$bvz;
      echo vz($bvz), $pas_tri[0], PHP_EOL;
  }
}

function pascal_triangle($n, &$pas_tri) {
// Calculate the $n'th line 0.. middle
  $pas_tri = array_fill(0, intdiv($n + 1, 2) + 1, 0);
  $pas_tri[0] = 1;
  $j = 1;
  while ($j <= $n) {
    $j++;
    $k = intdiv($j, 2);
    $pas_tri[$k] = $pas_tri[$k - 1];
    while ($k >= 1) {
      $pas_tri[$k] += $pas_tri[$k - 1];
      $k--;
    }
  }
}

function is_prime($n):bool {
  if ($n > PAS_TRI_MAX) {
    echo $n, " is out of range", PHP_EOL;
    exit;
  }
  $pas_tri = [];
  pascal_triangle($n, $pas_tri);
  $res = true;
  $i = intdiv($n, 2);
  while ($res && ($i > 1)) {
    $res = $res && ($pas_tri[$i] % $n == 0);
    --$i;
  }
  return $res;
}

for ($n = 0; $n <= 9; $n++)
  expand_poly($n);
for ($n = 2; $n <= PAS_TRI_MAX; $n++)
  if (is_prime($n))
    echo str_pad($n, 3, " ", STR_PAD_LEFT);
echo PHP_EOL;
?>

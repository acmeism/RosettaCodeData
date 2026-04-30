<?php
// Abundant, deficient and perfect number classifications
const MAX_NUMBER = 20000;
$pds = array_fill(0, MAX_NUMBER, 1);
// $pds[$k] proper divisor sums of $k + 1 ($k + 1 because of indexing from 0)
$a_count = 0;
$d_count = 0;
$p_count = 0;
$pds[0] = 0;
for ($i = 2; $i <= MAX_NUMBER; $i++)
  for ($j = $i + $i - 1; $j < MAX_NUMBER; $j += $i)
    $pds[$j] += $i;
// Classify the numbers and count each type
for ($i = 0; $i < MAX_NUMBER; $i++) {
  $d_sum = $pds[$i];
  if ($d_sum > $i + 1)
    $a_count++;
  else if ($d_sum <= $i)
    $d_count++;
  else
    $p_count++;
}
echo 'Up to '.MAX_NUMBER.PHP_EOL;
echo 'Number of abundants :'.str_pad($a_count, 6, " ", STR_PAD_LEFT).PHP_EOL;
echo 'Number of perfects  :'.str_pad($p_count, 6, " ", STR_PAD_LEFT).PHP_EOL;
echo 'Number of deficients:'.str_pad($d_count, 6, " ", STR_PAD_LEFT).PHP_EOL;
?>

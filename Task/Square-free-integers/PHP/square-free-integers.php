<?php
// Square-free integers

// return true if $n has no square divisors other than 1
function sq_free(int $n): bool {
  // quick exit for most common square
  $sq_f = ($n % 4 != 0);
  $i = 3;
  $sq = $i * $i;
  while ($sq <= $n && $sq_f) {
    if ($n % $sq == 0)
      $sq_f = false;
    else
    {
      $i += 2;
      $sq = $i * $i;
    }
  }
  return $sq_f;
}

// report number of square-free integers up to $limit
function report(int $limit) {
  echo 'Square-free integers up to '.str_pad($limit, 6, ' ', STR_PAD_LEFT).': ';
  $count = 0;
  for ($i = 1; $i <= $limit; $i++)
    if (sq_free($i))
      $count++;
  echo str_pad($count, 5, ' ', STR_PAD_LEFT).' were found.'.PHP_EOL;
}

$count = 0;
echo 'Square free integers up to 145:'.PHP_EOL;
for ($i = 1; $i <= 145; $i++)
  if (sq_free($i)) {
    echo str_pad($i, 4, ' ', STR_PAD_LEFT);
    $count++;
    if ($count % 10 == 0)
      echo PHP_EOL;
  }
echo $count.' were found.'.PHP_EOL.PHP_EOL;

report(100);
report(1000);
report(10000);
report(100000);
?>

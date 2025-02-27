<?php
// Leonardo numbers

function echo_Leonardo_nums($l0, $l1, $sum, $lmt, $what) {
  echo($what.' ('.$l0.', '.$l1.', '.$sum.'):'.PHP_EOL);
  if ($lmt >= 1)
    echo($l0.' ');
  if ($lmt >= 2)
    echo($l1.' ');
  for ($i = 3; $i <= $lmt; $i++) {
    echo(($l0 + $l1 + $sum).' ');
    $tmp = $l0;
    $l0 = $l1;
    $l1 = $tmp + $l1 + $sum;
  }
  echo(PHP_EOL);
}

echo_Leonardo_nums(1, 1, 1, 25, 'Leonardo numbers');
echo_Leonardo_nums(0, 1, 0, 25, 'Fibonacci numbers');
?>

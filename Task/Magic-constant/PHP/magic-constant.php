<?php
// Magic constant

// Returns the magic constant of a magic square of order $n + 2
function a($n) {
  $n2 = $n + 2;
  return floor(($n2 * (($n2 * $n2) + 1)) / 2);
}

// Returns the order of the magic square whose magic constant is at least $x
function inv_a($x) {
  return floor(pow(2 * $x, 1 / 3) + 1);
}

echo("The first 20 magic constants are ");
for ($n = 1; $n <= 20; $n++)
  echo(a($n)." ");
echo(PHP_EOL);
echo("The 1,000th magic constant is ".a(1000).PHP_EOL);
$e = 1;
for ($n = 1; $n <= 20; $n++) {
  $e *= 10;
  echo("10^".str_pad($n, 2, ' ', STR_PAD_LEFT));
  echo(": ".str_pad(inv_a($e), 9, ' ', STR_PAD_LEFT));
  echo(PHP_EOL);
}
?>

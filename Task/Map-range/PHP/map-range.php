<?php
// Map range

  function map_range($s, $a1, $a2, $b1, $b2) {
    return ($s - $a1) * ($b2 - $b1) / ($a2 - $a1) + $b1;
  }

for ($i = 0; $i <= 10; $i++) {
  $mr = map_range($i, 0, 10, -1, 0); // To avoid too long line.
  echo(str_pad($i, 2, ' ', STR_PAD_LEFT)
       .' maps to: '
       .str_pad(number_format($mr, 1, '.', ''), 4, ' ', STR_PAD_LEFT)
       .PHP_EOL);
}
?>

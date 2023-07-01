<?php
//Sort strings
$x = 'lions, tigers, and';
$y = 'bears, oh my!';
$z = '(from the "Wizard of OZ")';
$items = [$x, $y, $z];
sort($items);

list($x, $y, $z) = $items;

echo <<<EOT
Case 1:
  x = $x
  y = $y
  z = $z

EOT;

//Sort numbers
$x = 77444;
$y = -12;
$z = 0;
$items = [$x, $y, $z];
sort($items);

list($x, $y, $z) = $items;

echo <<<EOT
Case 2:
  x = $x
  y = $y
  z = $z

EOT;

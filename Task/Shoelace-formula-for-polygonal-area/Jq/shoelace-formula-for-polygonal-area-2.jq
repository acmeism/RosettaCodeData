def zip_shoelace:
   def sumprod: reduce .[] as [$x,$y] (0; . + ($x * $y));
   . as {$x, $y}
   | [$x, ($y[1:] + [$y[0]])] | transpose | sumprod as $a
   | [($x[1:] + [$x[0]]), $y] | transpose | sumprod as $b
   | ($a - $b) | length / 2;

{x: [3, 5, 12, 9, 5], y: [4, 11, 8, 5, 6] }
| zip_shoelace

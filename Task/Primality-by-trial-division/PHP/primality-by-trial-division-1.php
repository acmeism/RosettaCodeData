<?php
function prime($a) {
  if (($a % 2 == 0 && $a != 2) || $a < 2)
    return false;
  $limit = sqrt($a);
  for ($i = 2; $i <= $limit; $i++)
    if ($a % $i == 0)
      return false;
  return true;
}

foreach (range(1, 100) as $x)
  if (prime($x)) echo "$x\n";

?>

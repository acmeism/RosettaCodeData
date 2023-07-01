<?php
function horner($coeff, $x) {
    return array_reduce(array_reverse($coeff), function ($a, $b) use ($x) { return $a * $x + $b; }, 0);
}

$coeff = array(-19.0, 7, -4, 6);
$x = 3;
echo horner($coeff, $x), "\n";
?>

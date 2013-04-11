<?php
function horner($coeff, $x) {
    $result = 0;
    foreach (array_reverse($coeff) as $c)
        $result = $result * $x + $c;
    return $result;
}

$coeff = array(-19.0, 7, -4, 6);
$x = 3;
echo horner($coeff, $x), "\n";
?>

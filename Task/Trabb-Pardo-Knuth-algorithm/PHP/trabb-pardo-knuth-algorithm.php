<?php
// Trabb Pardo-Knuth algorithm
// Used "magic numbers" because of strict specification of the algorithm.

function f($n)
{
    return sqrt(abs($n)) + 5 * $n * $n * $n;
}

$sArray = [];
echo "Enter 11 numbers.\n";
for ($i = 0; $i <= 10; $i++) {
    echo $i + 1, " - Enter number: ";
    array_push($sArray, (float)fgets(STDIN));
}
echo PHP_EOL;
// Reverse
$sArray = array_reverse($sArray);
// Results
foreach ($sArray as $s) {
    $r = f($s);
    echo "f(", $s, ") = ";
    if ($r > 400)
        echo "overflow\n";
    else
        echo $r, PHP_EOL;
}
?>

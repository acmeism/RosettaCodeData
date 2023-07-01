<?php
// Almost prime

function isKPrime($n, $k)
{
    $f = 0;
    for ($j = 2; $j <= $n; $j++) {
        while ($n % $j == 0) {
            if ($f == $k)
                return false;
            $f++;
            $n = floor($n / $j);
        } // while
    } // for $j
    return ($f == $k);
}

for ($k = 1; $k <= 5; $k++) {
    echo "k = ", $k, ":";
    $i = 2;
    $c = 0;
    while ($c < 10) {
        if (isKPrime($i, $k)) {
            echo " ", str_pad($i, 3, ' ', STR_PAD_LEFT);
            $c++;
        }
        $i++;
    }
    echo PHP_EOL;
}
?>

<?php
// Digital root

function rootAndPers($n, $bas)
// Calculate digital root and persistance
{
    $pers = 0;
    while ($n >= $bas) {
        $s = 0;
        do {
            $s += $n % $bas;
            $n = floor($n / $bas);
        } while ($n > 0);
        $pers++;
        $n = $s;
    }
    return array($n, $pers);
}

foreach ([1, 14, 267, 8128, 39390, 588225, 627615] as $a) {
    list($root, $pers) = rootAndPers($a, 10);
    echo str_pad($a, 7, ' ', STR_PAD_LEFT);
    echo str_pad($pers, 6, ' ', STR_PAD_LEFT);
    echo str_pad($root, 6, ' ', STR_PAD_LEFT), PHP_EOL;
}
?>

<?php

function is_prime($n) {
    if ($n <= 3) {
        return $n > 1;
    } elseif (($n % 2 == 0) or ($n % 3 == 0)) {
        return false;
    }
    $i = 5;
    while ($i * $i <= $n) {
        if ($n % $i == 0) {
            return false;
        }
        $i += 2;
        if ($n % $i == 0) {
            return false;
        }
        $i += 4;
    }
    return true;
}

function is_emirp($n) {
    $r = (int) strrev((string) $n);
    return (($r != $n) and is_prime($r) and is_prime($n));
}

$c = $x = 0;
$first20 = $between = '';
do {
    $x++;
    if (is_emirp($x)) {
        $c++;
        if ($c <= 20) {
            $first20 .= $x . ' ';
        }
        if (7700 <= $x and $x <= 8000) {
            $between .= $x . ' ';
        }
    }
} while ($c < 10000);

echo
    'First twenty emirps :', PHP_EOL, $first20, PHP_EOL,
    'Emirps between 7,700 and 8,000 :', PHP_EOL, $between, PHP_EOL,
    'The 10,000th emirp :', PHP_EOL, $x, PHP_EOL;

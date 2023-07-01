<?php

function isSierpinskiCarpetPixelFilled($x, $y) {
    while (($x > 0) or ($y > 0)) {
        if (($x % 3 == 1) and ($y % 3 == 1)) {
            return false;
        }
        $x /= 3;
        $y /= 3;
    }
    return true;
}

function sierpinskiCarpet($order) {
    $size = pow(3, $order);
    for ($y = 0 ; $y < $size ; $y++) {
        for ($x = 0 ; $x < $size ; $x++) {
            echo isSierpinskiCarpetPixelFilled($x, $y) ? '#' : ' ';
        }
        echo PHP_EOL;
    }
}

for ($order = 0 ; $order <= 3 ; $order++) {
    echo 'N=', $order, PHP_EOL;
    sierpinskiCarpet($order);
    echo PHP_EOL;
}

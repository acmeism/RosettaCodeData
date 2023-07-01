<?php

function thueMorseSequence($length) {
    $sequence = '';
    for ($digit = $n = 0 ; $n < $length ; $n++) {
        $x = $n ^ ($n - 1);
        if (($x ^ ($x >> 1)) & 0x55555555) {
            $digit = 1 - $digit;
        }
        $sequence .= $digit;
    }
    return $sequence;
}

for ($n = 10 ; $n <= 100 ; $n += 10) {
    echo sprintf('%3d', $n), ' : ', thueMorseSequence($n), PHP_EOL;
}

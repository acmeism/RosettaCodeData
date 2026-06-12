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

for ($i = 0 ; $i <= 63 ; $i++) {
    $pow = pow(2, $i) - 1;
    $mersenne = is_prime($pow);
    if ($mersenne) {
        echo '2 ^ ', $i, ' - 1', PHP_EOL;
    }
}

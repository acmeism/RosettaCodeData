<?php

function E($k, $n) {
    $s = array();
    for ($i = 0; $i < $n; $i++) {
        $s[] = $i < $k ? array(1) : array(0);
    }

    $d = $n - $k;
    $n = max($k, $d);
    $k = min($k, $d);
    $z = $d;

    while ($z > 0 || $k > 1) {
        for ($i = 0; $i < $k; $i++) {
            $s[$i] = array_merge($s[$i], $s[count($s) - 1 - $i]);
        }
        $s = array_slice($s, 0, -$k);
        $z = $z - $k;
        $d = $n - $k;
        $n = max($k, $d);
        $k = min($k, $d);
    }

    $result = array();
    foreach ($s as $sublist) {
        $result = array_merge($result, $sublist);
    }
    return $result;
}

// Example usage
echo implode('', E(5, 13)); // 1001010010100

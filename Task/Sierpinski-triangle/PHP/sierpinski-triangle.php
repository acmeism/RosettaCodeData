<?php

function sierpinskiTriangle($order) {
    $char = '#';
    $n = 1 << $order;
    $line = array();
    for ($i = 0 ; $i <= 2 * $n ; $i++) {
        $line[$i] = ' ';
    }
    $line[$n] = $char;
    for ($i = 0 ; $i < $n ; $i++) {
        echo implode('', $line), PHP_EOL;
        $u = $char;
        for ($j = $n - $i ; $j < $n + $i + 1 ; $j++) {
            $t = ($line[$j - 1] == $line[$j + 1] ? ' ' : $char);
            $line[$j - 1] = $u;
            $u = $t;
        }
        $line[$n + $i] = $t;
        $line[$n + $i + 1] = $char;
    }
}

sierpinskiTriangle(4);

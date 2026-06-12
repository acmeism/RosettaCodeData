<?php

$n = 9; // the number of rows

for ($i = 1; $i <= $n; $i++) {
    for ($j = 1; $j <= $n; $j++) {
        echo ($i == $j || $i == $n - $j + 1) ? ' 1' : ' 0';
    }
    echo "\n";
}

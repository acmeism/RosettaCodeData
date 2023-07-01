<?php
$n = 15;
$t[1] = 1;
foreach (range(1, $n+1) as $i) {
    foreach (range($i, 1-1) as $j) {
        $t[$j] += $t[$j - 1];
    }
    $t[$i +1] = $t[$i];
    foreach (range($i+1, 1-1) as $j) {
        $t[$j] += $t[$j -1];
    }
    print ($t[$i+1]-$t[$i])."\t";
}

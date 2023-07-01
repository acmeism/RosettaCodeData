<?php

function sumDivs ($n) {
    $sum = 1;
    for ($d = 2; $d <= sqrt($n); $d++) {
        if ($n % $d == 0) $sum += $n / $d + $d;
    }
    return $sum;
}

for ($n = 2; $n < 20000; $n++) {
    $m = sumDivs($n);
    if ($m > $n) {
        if (sumDivs($m) == $n) echo $n."&ensp;".$m."<br />";
    }
}

?>

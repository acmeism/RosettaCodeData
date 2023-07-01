<?php

$pwr = array_fill(0, 10, 0);

function isMunchhausen($n)
{
    global $pwr;
    $sm = 0;
    $temp = $n;
    while ($temp) {
        $sm= $sm + $pwr[($temp % 10)];
        $temp = (int)($temp / 10);
    }
    return $sm == $n;
}

for ($i = 0; $i < 10; $i++) {
    $pwr[$i] = pow((float)($i), (float)($i));
}

for ($i = 1; $i < 5000 + 1; $i++) {
    if (isMunchhausen($i)) {
        echo $i . PHP_EOL;
    }
}

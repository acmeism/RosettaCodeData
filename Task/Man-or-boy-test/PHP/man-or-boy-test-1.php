<?php
function A($k,$x1,$x2,$x3,$x4,$x5) {
    $b = function () use (&$b,&$k,$x1,$x2,$x3,$x4) {
        return A(--$k,$b,$x1,$x2,$x3,$x4);
    };
    return $k <= 0 ? $x4() + $x5() : $b();
}

echo A(10, function () { return  1; },
           function () { return -1; },
           function () { return -1; },
           function () { return  1; },
           function () { return  0; }) . "\n";
?>

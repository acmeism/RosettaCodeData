<?php
function fib($n) {
    if ($n < 0)
        throw new Exception('Negative numbers not allowed');
    $f = function($n) use (&$f) {
        if ($n < 2)
            return 1;
        else
            return $f($n-1) + $f($n-2);
    };
    return $f($n);
}
echo fib(8), "\n";
?>

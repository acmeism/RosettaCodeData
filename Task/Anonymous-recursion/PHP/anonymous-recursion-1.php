<?php
function fib($n) {
    if ($n < 0)
        throw new Exception('Negative numbers not allowed');
    else if ($n < 2)
        return 1;
    else {
        $f = __FUNCTION__;
        return $f($n-1) + $f($n-2);
    }
}
echo fib(8), "\n";
?>

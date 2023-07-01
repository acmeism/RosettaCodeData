<?php
function fib($n) {
    if ($n < 0)
        throw new Exception('Negative numbers not allowed');
    $f = function($n) { // This function must be called using call_user_func() only
        if ($n < 2)
            return 1;
        else {
            $g = debug_backtrace()[1]['args'][0];
            return call_user_func($g, $n-1) + call_user_func($g, $n-2);
        }
    };
    return call_user_func($f, $n);
}
echo fib(8), "\n";
?>

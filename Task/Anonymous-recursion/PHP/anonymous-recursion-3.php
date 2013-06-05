<?php
class fib_helper {
    function __invoke($n) {
        if ($n < 2)
            return 1;
        else
            return $this($n-1) + $this($n-2);
    }
}

function fib($n) {
    if ($n < 0)
        throw new Exception('Negative numbers not allowed');
    $f = new fib_helper();
    return $f($n);
}
echo fib(8), "\n";
?>

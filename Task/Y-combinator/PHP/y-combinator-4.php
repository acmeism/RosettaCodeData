<?php
function pseudoY($f) {
    $g = function($w) use ($f) {
        return $f->bindTo(function() use ($w) {
            return call_user_func_array($w($w), func_get_args());
        });
    };
    return $g($g);
}

$factorial = pseudoY(function($n) {
    return $n > 1 ? $n * $this($n - 1) : 1;
});
echo $factorial(10), "\n";

$fibonacci = pseudoY(function($n) {
    return $n > 1 ? $this($n - 1) + $this($n - 2) : $n;
});
echo $fibonacci(10), "\n";
?>

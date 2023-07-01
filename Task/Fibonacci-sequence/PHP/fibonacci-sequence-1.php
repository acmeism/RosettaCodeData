function fibIter($n) {
    if ($n < 2) {
        return $n;
    }
    $fibPrev = 0;
    $fib = 1;
    foreach (range(1, $n-1) as $i) {
        list($fibPrev, $fib) = array($fib, $fib + $fibPrev);
    }
    return $fib;
}

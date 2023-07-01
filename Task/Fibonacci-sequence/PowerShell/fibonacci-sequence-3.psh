function fib($n) {
    switch ($n) {
        0            { return 0 }
        1            { return 1 }
        { $_ -lt 0 } { return [Math]::Pow(-1, -$n + 1) * (fib (-$n)) }
        default      { return (fib ($n - 1)) + (fib ($n - 2)) }
    }
}

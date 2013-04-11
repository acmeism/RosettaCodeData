sub Y ($f) { { .($_) }( -> $y { $f({ $y($y)($^arg) }) } ) }
sub fac ($f) { sub ($n) { $n < 2 ?? 1 !! $n * $f($n - 1) } }
say map(Y(&fac), ^10).perl;
sub fib ($f) { sub ($n) { $n < 2 ?? $n !! $f($n - 1) + $f($n - 2) } }
say map(Y(&fib), ^10).perl;

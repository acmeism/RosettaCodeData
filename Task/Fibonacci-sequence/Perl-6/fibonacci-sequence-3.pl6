constant @neg-fib = 0, 1, *-* ... *;
sub fib ($n) { $n >= 0 ?? @fib[$n] !! @neg-fib[-$n] }

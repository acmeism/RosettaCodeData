my constant @neg_fib = 0, 1, *-* ... *;
sub fib ($n) { $n >= 0 and @fib[$n] or @neg_fib[-$n]; }

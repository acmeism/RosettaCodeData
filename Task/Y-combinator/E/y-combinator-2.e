? pragma.enable("accumulator")
? accum [] for i in 0..!10 { _.with(y(fac)(i)) }
[1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880]

? accum [] for i in 0..!10 { _.with(y(fib)(i)) }
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

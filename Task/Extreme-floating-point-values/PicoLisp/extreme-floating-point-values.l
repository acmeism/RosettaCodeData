(load "@lib/math.l")

: (exp 1000.0)  # Too large for IEEE floats
-> T

: (+ 1 2 NIL 3)  # NaN propagates
-> NIL

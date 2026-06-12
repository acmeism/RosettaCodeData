USING: formatting kernel math math.functions math.primes
math.ranges sequences tools.memory.private ;

1 199 2 <range> [
    dup 3 ^ 2 + dup prime?
    [ commas "n = %3d => n³ + 2 = %9s\n" printf ] [ 2drop ] if
] each

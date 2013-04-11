sub fib (Int $n --> Int) {
    constant φ1 = 1 / constant φ = (1 + sqrt 5)/2;
    constant invsqrt5 = 1 / sqrt 5;

    floor invsqrt5 * (φ**$n + φ1**$n);
}

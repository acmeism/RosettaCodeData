function sum_multiples_gmp($max, $divisor) {
    // Number of multiples of $divisor <= $max
    $num = gmp_div($max, $divisor);
    // Sum of multiples of $divisor
    return gmp_div(gmp_mul(gmp_mul($divisor, $num), gmp_add($num, 1)), 2);
}

for ($i = 0, $n = gmp_init(10) ; $i < 21 ; $i++, $n = gmp_mul($n, 10)) {
    $max = gmp_sub($n, 1);
    $sum =
        gmp_sub(
            gmp_add(
                sum_multiples_gmp($max, 3),
                sum_multiples_gmp($max, 5)
            ),
            sum_multiples_gmp($max, 15)
        );
    printf('%22s : %s' . PHP_EOL, gmp_strval($n), $sum);
}

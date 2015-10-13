multi horner(Numeric $c, $) { $c }
multi horner(Pair $c, $x) {
    $c.key + $x * horner( $c.value, $x )
}

say horner( [=>](-19, 7, -4, 6 ), 3 );

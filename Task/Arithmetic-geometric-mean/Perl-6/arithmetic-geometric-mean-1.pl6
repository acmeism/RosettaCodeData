sub agm( $a is copy, $g is copy ) {
    ($a, $g) = ($a + $g)/2, sqrt $a * $g until $a ≅ $g;
    return $a;
}

say agm 1, 1/sqrt 2;

sub agm( $a is copy, $g is copy ) {
    loop {
        given ($a + $g)/2, sqrt $a * $g {
            return $a if @$_ ~~ ($a, $g);
            ($a, $g) = @$_;
        }
    }
}

say agm 1, 1/sqrt 2;

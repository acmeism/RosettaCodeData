sub horner {
    my ($coeff, $x) = @_;
    @$coeff and
    $$coeff[0] + $x * horner( [@$coeff[1 .. $#$coeff]], $x )
}

print horner( [ -19, 7, -4, 6 ], 3 );

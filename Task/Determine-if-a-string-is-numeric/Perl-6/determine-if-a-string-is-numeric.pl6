sub is-number( $term --> Bool ) {
    ?($term ~~ /\d/) and +$term ~~ Numeric;
}

printf "%10s %s\n", "<$_>", is-number( $_ ) for
<1 1.2 1.2.3 -6 1/2 12e B17 1.3e+12 1.3e12 -2.6e-3 zero
0x 0xA10 0b1001 0o16 0o18 2+5i>, '1 1 1', '', ' ';

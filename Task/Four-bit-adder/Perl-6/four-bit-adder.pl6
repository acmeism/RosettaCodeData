sub xor ($a, $b) { ($a and not $b) or (not $a and $b) }

sub half-adder ($a, $b) {
    return xor($a, $b), ($a and $b);
}

sub full-adder ($a, $b, $c0) {
    my ($ha0_s, $ha0_c) = half-adder($c0, $a);
    my ($ha1_s, $ha1_c) = half-adder($ha0_s, $b);
    return $ha1_s, ($ha0_c or $ha1_c);
}

sub four-bit-adder ($a0, $a1, $a2, $a3, $b0, $b1, $b2, $b3) {
    my ($fa0_s, $fa0_c) = full-adder($a0, $b0, 0);
    my ($fa1_s, $fa1_c) = full-adder($a1, $b1, $fa0_c);
    my ($fa2_s, $fa2_c) = full-adder($a2, $b2, $fa1_c);
    my ($fa3_s, $fa3_c) = full-adder($a3, $b3, $fa2_c);

    return $fa0_s, $fa1_s, $fa2_s, $fa3_s, $fa3_c;
}

{
    use Test;

    is four-bit-adder(1, 0, 0, 0, 1, 0, 0, 0), (0, 1, 0, 0, 0), '1 + 1 == 2';
    is four-bit-adder(1, 0, 1, 0, 1, 0, 1, 0), (0, 1, 0, 1, 0), '5 + 5 == 10';
    is four-bit-adder(1, 0, 0, 1, 1, 1, 1, 0)[4], 1, '7 + 9 == overflow';
}

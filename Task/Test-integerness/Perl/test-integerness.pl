use Math::Complex;

sub is_int {
    my $number = shift;

    if (ref $number eq 'Math::Complex') {
        return 0 if $number->Im != 0;
        $number = $number->Re;
    }

    return int($number) == $number;
}

for (5, 4.1, sqrt(2), sqrt(4), 1.1e10, 3.0-0.0*i, 4-3*i, 5.6+0*i) {
    printf "%20s is%s an integer\n", $_, (is_int($_) ? "" : " NOT");
}

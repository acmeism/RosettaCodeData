sub synthetic_division {
    my($numerator,$denominator) = @_;
    my @result = @$numerator;
    my $end    = @$denominator-1;

    for my $i (0 .. @$numerator-($end+1)) {
        next unless $result[$i];
        $result[$i]    /= @$denominator[0];
        $result[$i+$_] -= @$denominator[$_] * $result[$i] for 1 .. $end;
    }

    return join(' ', @result[0 .. @result-($end+1)]), join(' ', @result[-$end .. -1]);
}

sub poly_divide {
    *n = shift; *d = shift;
    my($quotient,$remainder)= synthetic_division( \@n, \@d );
    "[@n] / [@d] = [$quotient], remainder [$remainder]\n";
}

print poly_divide([1, -12, 0, -42], [1, -3]);
print poly_divide([1, 0, 0, 0, -2], [1, 1, 1, 1]);

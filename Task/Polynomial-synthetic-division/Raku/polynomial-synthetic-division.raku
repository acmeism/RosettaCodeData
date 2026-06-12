sub synthetic-division ( @numerator, @denominator ) {
    my @result = @numerator;
    my $end    = @denominator.end;

    for ^(@numerator-$end) -> $i {
        @result[$i]    /= @denominator[0];
        @result[$i+$_] -= @denominator[$_] * @result[$i] for 1..$end;
    }

    'quotient' => @result[0 ..^ *-$end],
    'remainder' => @result[*-$end .. *];
}

my @tests =
[1, -12, 0, -42], [1, -3],
[1, 0, 0, 0, -2], [1, 1, 1, 1];

for @tests -> @n, @d {
    my %result = synthetic-division( @n, @d );
    say "[{@n}] / [{@d}] = [%result<quotient>], remainder [%result<remainder>]";
}

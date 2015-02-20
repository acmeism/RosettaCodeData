sub mat_elem(@a, $y, $x, $n) is rw { @a[ $y * $n + $x ] }
sub swap_row(@a, @b, $r1, $r2, $n) {
    return if $r1 == $r2;
    for ^$n -> $i {
	(
	    mat_elem(@a, $r1, $i, $n),
	    mat_elem(@a, $r2, $i, $n)
	).=reverse;
    }
    @b[$r1, $r2].=reverse;
}

sub gauss_eliminate(@a, @b, $n) {
    sub A($y, $x) is rw { mat_elem(@a, $y, $x, $n) }
    my ($i, $j, $col, $row, $max_row, $dia);
    my ($max, $tmp);
    for ^$n -> $dia {
	for $dia ^..^ $n -> $row {
	    swap_row @a, @b, $dia,
	    max(:by({ abs(A($_, $dia)) }), $dia ^..^ $n),
	    $n;
	    $tmp = A($row, $dia) / A($dia, $dia);
	    for $dia ^..^ $n -> $col {
		A($row, $col) -= $tmp * A($dia, $col);
	    }
	    A($row, $dia) = 0;
	    @b[$row] -= $tmp * @b[$dia];
	}
    }
    my @x;
    for $n - 1, $n - 2 ... 0 -> $row {
	$tmp = @b[$row];
	for $n - 1, $n - 2 ...^ $row -> $j {
	    $tmp -= @x[$j] * A($row, $j);
	}
	@x[$row] = $tmp / A($row, $row);
    }
    return @x;
}

sub MAIN {
    my @a = <
        1.00 0.00 0.00  0.00  0.00   0.00
        1.00 0.63 0.39  0.25  0.16   0.10
        1.00 1.26 1.58  1.98  2.49   3.13
        1.00 1.88 3.55  6.70 12.62  23.80
        1.00 2.51 6.32 15.88 39.90 100.28
        1.00 3.14 9.87 31.01 97.41 306.02
    >;
    my @b = <
        -0.01 0.61 0.91 0.99 0.60 0.02
    >;
    .say for gauss_eliminate(@a, @b, 6);
}

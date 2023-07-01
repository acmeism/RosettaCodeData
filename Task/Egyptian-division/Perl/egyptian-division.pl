sub egyptian_divmod {
    my($dividend, $divisor) = @_;
    die "Invalid divisor" if $divisor <= 0;

    my @table = ($divisor);
    push @table, 2*$table[-1] while $table[-1] <= $dividend;

    my $accumulator = 0;
    for my $k (reverse 0 .. $#table) {
        next unless $dividend >= $table[$k];
        $accumulator += 1 << $k;
        $dividend    -= $table[$k];
    }
    $accumulator, $dividend;
}

for ([580,34], [578,34], [7532795332300578,235117]) {
    my($n,$d) = @$_;
    printf "Egyption divmod %s %% %s = %s remainder %s\n", $n, $d, egyptian_divmod( $n, $d )
}

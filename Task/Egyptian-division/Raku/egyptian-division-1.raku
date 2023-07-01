sub egyptian-divmod (Real $dividend is copy where * >= 0, Real $divisor where * > 0) {
    my $accumulator = 0;
    ([1, $divisor], { [.[0] + .[0], .[1] + .[1]] } … ^ *.[1] > $dividend)
      .reverse.map: { $dividend -= .[1], $accumulator += .[0] if $dividend >= .[1] }
    $accumulator, $dividend;
}

#TESTING
for 580,34, 578,34, 7532795332300578,235117 -> $n, $d {
    printf "%s divmod %s = %s remainder %s\n",
        $n, $d, |egyptian-divmod( $n, $d )
}

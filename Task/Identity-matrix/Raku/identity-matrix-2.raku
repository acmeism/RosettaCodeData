sub identity-matrix($n) {
    my @id = [0 xx $n] xx $n;
    @id[$_][$_] = 1 for ^$n;
    @id;
}

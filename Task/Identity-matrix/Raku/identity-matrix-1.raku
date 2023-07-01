sub identity-matrix($n) {
    my @id;
    for flat ^$n X ^$n -> $i, $j {
        @id[$i][$j] = +($i == $j);
    }
    @id;
}

.say for identity-matrix(5);

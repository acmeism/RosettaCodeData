sub identity-matrix($n) {
    [1, |(0 xx $n-1)], *.rotate(-1) ... *[*-1]
}

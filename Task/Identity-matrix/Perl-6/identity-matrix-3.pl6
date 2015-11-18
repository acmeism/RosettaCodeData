sub identity-matrix($n) {
    ([1, |(0 xx $n-1)].item, *.rotate(-1).item ... *)[^$n]
}

sub propdivsum (\x) {
    [+] flat(x > 1, gather for 2 .. x.sqrt.floor -> \d {
        my \y = x div d;
        if y * d == x { take d; take y unless y == d }
    })
}

say bag map { propdivsum($_) <=> $_ }, 1..20000

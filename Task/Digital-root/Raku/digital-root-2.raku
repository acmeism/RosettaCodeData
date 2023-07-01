sub digital-root ($r, :$base = 10) {
    my &sum = { .comb.map({:36($_)}).sum.base($base) }

    return .[*-1], .elems-1
        given $r.base($base), &sum … { .chars == 1 }
}

multi horner(@c, $x) {
    @c > 1 ?? @c.head + $x * samewith(@c.tail(*-1), $x) !! @c.pick
}

say horner( [-19, 7, -4, 6 ], 3 );

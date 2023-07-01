proto combs_with_rep (UInt, @ ) { * }
multi combs_with_rep (0,    @ ) { () }
multi combs_with_rep ($,    []) { () }
multi combs_with_rep (1,    @a) { map { $_, }, @a }
multi combs_with_rep ($n, [$head, *@tail]) {
    |combs_with_rep($n - 1, ($head, |@tail)).map({ $head, |@_ }),
    |combs_with_rep($n, @tail);
}

say sort gather {
    for 3..9 -> $d {
        for combs_with_rep($d, [^10]) -> @digits {
            .take if $d == .comb.elems and @digits.join == .comb.sort.join given sum @digits X** $d;
        }
    }
}

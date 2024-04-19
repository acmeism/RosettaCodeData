sub derangements(@l) {
    @l.permutations.grep(-> @p { none(@p Zeqv @l) })
}

sub prefix:<!>(Int $n) {
    (1, 0, 1, -> $a, $b { ($++ + 2) × ($b + $a) } ... *)[$n]
}

say 'derangements([1, 2, 3, 4])';
say derangements([1, 2, 3, 4]), "\n";

say 'n == !n == derangements(^n).elems';
for 0 .. 9 -> $n {
    say "!$n == { !$n } == { derangements(^$n).elems }"
}

sub is-derangement(List $l) {
    return not grep { $l[$_] == $_ }, 0..($l.elems - 1);
}

# task 1
sub derangements(Range $x) {
    $x.permutations.grep( *.&is-derangement )
}

# task 2
.say for (0..4).&derangements;

# task 3
sub prefix:<!>(Int $x) {
    return +derangements(^$x);
}

# task 4
for ^9 -> $n {
    say "number: " ~ $n;
    say "count: " ~ !$n;
    say "derangements: ";
    .say for (0..$n-1).&derangements;
}

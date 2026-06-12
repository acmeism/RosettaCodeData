sub is-updown (@seq) {
    all (1..^@seq).map: { $_ % 2 ?? (@seq[$_] > @seq[$_-1]) !! (@seq[$_] < @seq[$_-1]) }
}

for (1..5) {
    say "\nPermutations for N = $_:";
    for (1..$_).permutations { .say if .&is-updown }
}

say "\n M  zigzag number\n--  -------------";

sub bt (@seq) { map *.tail, (@seq[0], {[[\+] flat @seq[++$ ], .reverse]}…*) }

printf("%2d  %d\n", ++$, $_) for (flat 1, 0 xx *).&bt[1..30]

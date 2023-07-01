sub digital-root ($r, :$base = 10) {
    my $root = $r.base($base);
    my $persistence = 0;
    while $root.chars > 1 {
        $root = $root.comb.map({:36($_)}).sum.base($base);
        $persistence++;
    }
    $root, $persistence;
}

my @testnums =
    627615,
    39390,
    588225,
    393900588225,
    58142718981673030403681039458302204471300738980834668522257090844071443085937;

for 10, 8, 16, 36 -> $b {
    for @testnums -> $n {
        printf ":$b\<%s>\ndigital root %s, persistence %s\n\n",
            $n.base($b), digital-root $n, :base($b);
    }
}

use v5.36;

sub kmp_search ($S, $W) {
    my @S = split '', $S;
    my @W = split '', $W;

   sub kmp_table (@W) {
        my($pos,$cnd,@T) = (1,0,-1);
        for (; $pos < @W ; $pos++, $cnd++) {
            if ($W[$pos] eq $W[$cnd]) {
                $T[$pos]  = $T[$cnd]
            } else {
                $T[$pos]  = $cnd;
                while ($cnd >= 0 and $W[$pos] ne $W[$cnd]) { $cnd = $T[$cnd] }
            }
        }
        $T[$pos] = $cnd;
        @T
    }

    my @I;
    my ($k,@T) = (0,kmp_table @W);
    for (my $j=0; $j < @S;) {
        if ($W[$k] eq $S[$j]) {
            $j++; $k++;
            if ($k == @W) {
                push @I,  $j - $k;
                $k = $T[$k]
            }
        } else {
            ($j++, $k++) if ($k = $T[$k]) < 0
        }
    }
    @I
}

my @texts = (
    "GCTAGCTCTACGAGTCTA",
    "GGCTATAATGCGTA",
    "there would have been a time for such a word",
    "needle need noodle needle",
    "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
    "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk.",
);
my @pats = <TCTA TAATAAA word needle put and alfalfa>;

say "text$_ = $texts[$_]" for 0..$#texts;
say '';

for (0.. $#pats) {
    my $j = $_ < 5 ? $_ : $_-1 ; # for searching text4 twice
    say "Found '$pats[$_]' in 'text$j' at indices " . join ', ', kmp_search($texts[$j],$pats[$_]);
}

use ntheory "vecextract";
my @S=("a","b","c");
my @PS = map { "[".join(" ",vecextract(\@S,$_))."]" } 0..2**scalar(@S)-1;
say join("  ",@PS);

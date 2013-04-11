my @words;
my $maxlen = 0;
for slurp("unixdict.txt").lines {
    if .chars >= $maxlen and [le] .comb {
        if .chars > $maxlen {
            @words = ();
            $maxlen = .chars;
        }
        push @words, $_;
    }
}
say ~@words;

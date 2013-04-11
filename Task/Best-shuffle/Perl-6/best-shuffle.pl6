sub best-shuffle (Str $s) {
    my @orig = $s.comb;

    my @pos;
    # Fill @pos with positions in the order that we want to fill
    # them. (Once Rakudo has &roundrobin, this will be doable in
    # one statement.)
    {
        my %pos = classify { @orig[$^i] }, keys @orig;
        my @k = map *.key, sort *.value.elems, %pos;
        while %pos {
            for @k -> $letter {
                %pos{$letter} or next;
                push @pos, %pos{$letter}.pop;
                %pos{$letter}.elems or %pos.delete: $letter;
            }
        }
        @pos .= reverse;
    }

    my @letters = @orig;
    my @new = Any xx $s.chars;
    # Now fill in @new with @letters according to each position
    # in @pos, but skip ahead in @letters if we can avoid
    # matching characters that way.
    while @letters {
        my ($i, $p) = 0, shift @pos;
        ++$i while @letters[$i] eq @orig[$p] and $i < @letters.end;
        @new[$p] = splice @letters, $i, 1;
    }

    my $score = elems grep ?*, map * eq *, do @new Z @orig;

    @new.join, $score;
}

printf "%s, %s, (%d)\n", $_, best-shuffle $_
    for <abracadabra seesaw elk grrrrrr up a>;

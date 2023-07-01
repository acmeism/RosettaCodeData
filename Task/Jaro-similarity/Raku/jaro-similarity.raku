sub jaro ($s, $t) {
    return 1 if $s eq $t;

    my $s-len = + my @s = $s.comb;
    my $t-len = + my @t = $t.comb;
    my $match-distance = ($s-len max $t-len) div 2 - 1;

    my ($matches, @s-matches, @t-matches);
    for ^@s -> $i {
        my $start = 0 max $i - $match-distance;
        my $end   = $i + $match-distance min ($t-len - 1);

        for $start .. $end -> $j {
            next if @t-matches[$j] or @s[$i] ne @t[$j];
            (@s-matches[$i], @t-matches[$j]) = (1, 1);
            $matches++ and last;
        }
    }
    return 0 unless $matches;

    my ($k, $transpositions) = (0, 0);
    for ^@s -> $i {
        next unless @s-matches[$i];
        $k++ until  @t-matches[$k];
        $transpositions++ if @s[$i] ne @t[$k];
        $k++;
    }

    ( $matches/$s-len + $matches/$t-len + (($matches - $transpositions/2) / $matches) ) / 3
}

say jaro(.key, .value).fmt: '%.3f' for
    'MARTHA' => 'MARHTA', 'DIXON' => 'DICKSONX', 'JELLYFISH' => 'SMELLYFISH',
    'I repeat myself' => 'I repeat myself', '' => '';

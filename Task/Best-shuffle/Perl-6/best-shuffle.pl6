sub best-shuffle(Str $orig) {

    my @s = $orig.comb;
    my @t = @s.pick(*);

    for ^@s -> $i {
        for ^@s -> $j {
            if $i != $j and @t[$i] ne @s[$j] and @t[$j] ne @s[$i] {
                @t[$i, $j] = @t[$j, $i];
                last;
            }
        }
    }

    my $count = 0;
    for @t.kv -> $k,$v {
        ++$count if $v eq @s[$k]
    }

    return (@t.join, $count);
}

printf "%s, %s, (%d)\n", $_, best-shuffle $_
    for <abracadabra seesaw elk grrrrrr up a>;

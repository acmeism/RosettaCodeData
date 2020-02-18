sub swops(@a is copy) {
    my int $count = 0;
    until @a[0] == 1 {
        @a[ ^@a[0] ] .= reverse;
        ++$count;
    }
    $count
}

sub topswops($n) { max (1..$n).permutations.race.map: *.&swops }

say "$_ {topswops $_}" for 1 .. 10;

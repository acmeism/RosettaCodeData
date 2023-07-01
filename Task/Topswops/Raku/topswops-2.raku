sub swops($a is copy) {
    my int $count = 0;
    while (my \l = $a.ord) > 1 {
        $a = $a.substr(0, l).flip ~ $a.substr(l);
        ++$count;
    }
    $count
}

sub topswops($n) { max (1..$n).permutations.map: { .chrs.join.&swops } }

say "$_ {topswops $_}" for 1 .. 10;

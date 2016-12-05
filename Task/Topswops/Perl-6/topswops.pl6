sub swops(@a is copy) {
    my $count = 0;
    until @a[0] == 1 {
        @a[ ^@a[0] ] .= reverse;
        $count++;
    }
    return $count;
}

sub topswops($n) { (sort map &swops, (1..$n).permutations)[*-1] }

say "$_ {topswops $_}" for 1 .. 10;

sub postfix:<!>(@a) {
    @a == 1
        ?? [@a]
        !! do for @a -> $a {
                [ $a, @$_ ] for @a.grep(* != $a)!
           }
}

sub swops(@a is copy) {
    my $count = 0;
    until @a[0] == 1 {
        @a[ ^@a[0] ] .= reverse;
        $count++;
    }
    return $count;
}
sub topswops($n) { [max] map &swops, (1 .. $n)! }

say "$_ {topswops $_}" for 1 .. 10;

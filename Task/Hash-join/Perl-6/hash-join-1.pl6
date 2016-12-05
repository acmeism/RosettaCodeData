sub hash-join(@a, &a, @b, &b) {
    my %hash := @b.classify(&b);

    @a.map: -> $a {
        |(%hash{a $a} // next).map: -> $b { [$a, $b] }
    }
}

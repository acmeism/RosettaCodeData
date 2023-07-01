sub shuffle (@a is copy) {
    for 1 ..^ @a -> $n {
        my $k = (0 .. $n).pick;
        $k == $n or @a[$k, $n] = @a[$n, $k];
    }
    return @a;
}

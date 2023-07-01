sub compose {
    my ($f, $g) = @_;

    sub {
        $f -> ($g -> (@_));
    };
}
...
compose($flist1[$_], $flist2[$_]) -> (0.5)

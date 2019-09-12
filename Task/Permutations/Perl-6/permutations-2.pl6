sub next_perm ( @a is copy ) {
    my $j = @a.end - 1;
    return Nil if --$j < 0 while @a[$j] after @a[$j+1];

    my $aj = @a[$j];
    my $k  = @a.end;
    $k-- while $aj after @a[$k];
    @a[ $j, $k ] .= reverse;

    my $r = @a.end;
    my $s = $j + 1;
    @a[ $r--, $s++ ] .= reverse while $r > $s;
    return @a;
}

.say for [<a b c>], &next_perm ...^ !*;

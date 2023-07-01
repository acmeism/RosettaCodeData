while (<>) {
    my @columns = split;
    next if 3 < @columns;
    my ($word, $freq) = @columns[0, 2];
    for my $k (@keys) {
        $count{$k} += $freq if -1 != index $word, $k;
    }
}

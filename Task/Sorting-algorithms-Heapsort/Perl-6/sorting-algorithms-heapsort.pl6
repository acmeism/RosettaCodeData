sub heap_sort ( @list is rw ) {
    for ( 0 ..^ +@list div 2 ).reverse -> $start {
        _sift_down $start, @list.end, @list;
    }

    for ( 1 ..^ +@list ).reverse -> $end {
        @list[ 0, $end ] .= reverse;
        _sift_down 0, $end-1, @list;
    }
}

sub _sift_down ( $start, $end, @list is rw ) {
    my $root = $start;
    while ( my $child = $root * 2 + 1 ) <= $end {
        $child++ if $child + 1 <= $end and [<] @list[ $child, $child+1 ];
        return if @list[$root] >= @list[$child];
        @list[ $root, $child ] .= reverse;
        $root = $child;
    }
}

my @data = 6, 7, 2, 1, 8, 9, 5, 3, 4;
say 'Input  = ' ~ @data;
@data.&heap_sort;
say 'Output = ' ~ @data;

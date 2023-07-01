sub insertion_sort ( @a is copy ) {
    for 1 .. @a.end -> $i {
        my $value = @a[$i];
        my $j;
        loop ( $j = $i-1; $j >= 0 and @a[$j] > $value; $j-- ) {
            @a[$j+1] = @a[$j];
        }
        @a[$j+1] = $value;
    }
    return @a;
}

my @data = 22, 7, 2, -5, 8, 4;
say 'input  = ' ~ @data;
say 'output = ' ~ @data.&insertion_sort;

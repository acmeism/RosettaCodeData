sub shell_sort ( @a is copy ) {
    loop ( my $gap = (@a/2).round; $gap > 0; $gap = ( $gap * 5 / 11 ).round ) {
        for $gap .. @a.end -> $i {
            my $temp = @a[$i];

            my $j;
            loop ( $j = $i; $j >= $gap; $j -= $gap ) {
                my $v = @a[$j - $gap];
                last if $v <= $temp;
                @a[$j] = $v;
            }

            @a[$j] = $temp;
        }
    }
    return @a;
}
my @data = 22, 7, 2, -5, 8, 4;
say 'input  = ' ~ @data;
say 'output = ' ~ @data.&shell_sort;

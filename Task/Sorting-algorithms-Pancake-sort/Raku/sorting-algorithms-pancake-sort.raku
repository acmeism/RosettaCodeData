sub pancake_sort ( @a is copy ) {
    my $endpoint = @a.end;
    while $endpoint > 0 and not [<] @a {
        my $max_i = [0..$endpoint].max: { @a[$_] };
        my $max   = @a[$max_i];
        if @a[$endpoint] == $max {
            $endpoint-- while @a[$endpoint] == $max;
            next;
        }
        # @a[$endpoint] is not $max, so it needs flipping;
        # Flip twice if max is not already at the top.
        @a[0..$max_i]    .= reverse if $max_i != 0;
        @a[0..$endpoint] .= reverse;
        $endpoint--;
    }
    return @a;
}
my @data = 6, 7, 2, 1, 8, 9, 5, 3, 4;
say 'input  = ' ~ @data;
say 'output = ' ~ @data.&pancake_sort;

use 5.010;

sub zig_zag {
    my $n          = shift;
    my $max_number = $n**2;
    my @matrix;
    my $number = 0;
    for my $j ( 0 .. --$n ) {
        for my $i (
            $j % 2
            ? 0 .. $j
            : reverse 0 .. $j
          )
        {
            $matrix[$i][ $j - $i ] = $number++;
            #next if $j == $n;
            $matrix[ $n - $i ][ $n - ( $j - $i ) ] = $max_number - $number;
        }
    }
    return @matrix;
}

my @zig_zag_matrix = zig_zag(5);
say join "\t", @{$_} foreach @zig_zag_matrix;

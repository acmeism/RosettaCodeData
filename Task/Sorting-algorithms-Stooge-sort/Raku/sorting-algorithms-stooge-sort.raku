sub stoogesort( @L, $i = 0, $j = @L.end ) {
    @L[$j,$i] = @L[$i,$j] if @L[$i] > @L[$j];

    my $interval = $j - $i;

    if $interval > 1 {
         my $t = ( $interval + 1 ) div 3;
         stoogesort( @L, $i   , $j-$t );
         stoogesort( @L, $i+$t, $j    );
         stoogesort( @L, $i   , $j-$t );
    }
    return @L;
}

my @L = 1, 4, 5, 3, -6, 3, 7, 10, -2, -5;

stoogesort(@L).Str.say;

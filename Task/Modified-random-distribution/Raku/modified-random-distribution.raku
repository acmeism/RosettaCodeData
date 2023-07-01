sub modified_random_distribution ( Code $modifier --> Seq ) {
    return lazy gather loop {
        my ( $r1, $r2 ) = rand, rand;
        take $r1 if $modifier.($r1) > $r2;
    }
}
sub modifier ( Numeric $x --> Numeric ) {
    return 2 * ( $x < 1/2 ?? ( 1/2 - $x  )
                          !! ( $x  - 1/2 ) );
}
sub print_histogram ( @data, :$n-bins, :$width ) { # Assumes minimum of zero.
    my %counts = bag @data.map: { floor( $_ * $n-bins ) / $n-bins };
    my $max_value = %counts.values.max;
    sub hist { '■' x ( $width * $^count / $max_value ) }
    say ' Bin, Counts: Histogram';
    printf "%4.2f, %6d: %s\n", .key, .value, hist(.value) for %counts.sort;
}

my @d = modified_random_distribution( &modifier );

print_histogram( @d.head(50_000), :n-bins(20), :width(64) );

sub cantor ( Int $height ) {
    my $width = 3 ** ($height - 1);

    my @lines = ( "\c[FULL BLOCK]" x $width ) xx $height;

    my sub _trim_middle_third ( $len, $start, $index ) {
        my $seg = $len div 3
            or return;

        for ( $index ..^ $height ) X ( 0 ..^ $seg ) -> ( $i, $j ) {
            @lines[$i].substr-rw( $start + $seg + $j, 1 ) = ' ';
        }

        _trim_middle_third( $seg, $start + $_, $index + 1 ) for 0, $seg * 2;
    }

    _trim_middle_third( $width, 0, 1 );
    return @lines;
}

.say for cantor(5);

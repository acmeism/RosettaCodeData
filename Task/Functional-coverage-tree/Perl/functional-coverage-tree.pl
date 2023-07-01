use strict;
use warnings;

sub walktree {
    my @parts;
    while( $_[0] =~ /(?<head> (\s*)   \N+\n  )         # split off one level as 'head' (or terminal 'leaf')
                     (?<body> (?:\2 \s\N+\n)*)/gx ) {  # next sub-level is 'body' (defined by extra depth of indentation)

        my($head, $body) = ($+{head}, $+{body});
        $head =~ /^.*?      \|      # ignore name
                  (\S*) \s* \|      # save weight
                  (\S*)       /x;   # save coverage
        my $weight   = sprintf '%-8s',  $1 || 1;
        my $coverage = sprintf '%-10s', $2 || 0;
        my($w, $wsum) = (0, 0);

        $head .= $_->[0],
        $w    += $_->[1],
        $wsum += $_->[1] * $_->[2]
              for walktree( $body );

        $coverage = sprintf '%-10.2g', $wsum/$w unless $w == 0;
        push @parts, [ $head =~ s/\|.*/|$weight|$coverage|/r, $weight, $coverage ];
    }
    return @parts;
}

print $_->[0] for walktree( join '', <DATA> );

__DATA__
NAME_HIERARCHY                  |WEIGHT  |COVERAGE  |
cleaning                        |        |          |
    house1                      |40      |          |
        bedrooms                |        |0.25      |
        bathrooms               |        |          |
            bathroom1           |        |0.5       |
            bathroom2           |        |          |
            outside_lavatory    |        |1         |
        attic                   |        |0.75      |
        kitchen                 |        |0.1       |
        living_rooms            |        |          |
            lounge              |        |          |
            dining_room         |        |          |
            conservatory        |        |          |
            playroom            |        |1         |
        basement                |        |          |
        garage                  |        |          |
        garden                  |        |0.8       |
    house2                      |60      |          |
        upstairs                |        |          |
            bedrooms            |        |          |
                suite_1         |        |          |
                suite_2         |        |          |
                bedroom_3       |        |          |
                bedroom_4       |        |          |
            bathroom            |        |          |
            toilet              |        |          |
            attics              |        |0.6       |
        groundfloor             |        |          |
            kitchen             |        |          |
            living_rooms        |        |          |
                lounge          |        |          |
                dining_room     |        |          |
                conservatory    |        |          |
                playroom        |        |          |
            wet_room_&_toilet   |        |          |
            garage              |        |          |
            garden              |        |0.9       |
            hot_tub_suite       |        |1         |
        basement                |        |          |
            cellars             |        |1         |
            wine_cellar         |        |1         |
            cinema              |        |0.75      |

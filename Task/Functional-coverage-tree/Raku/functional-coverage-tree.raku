sub walktree ($data) {
    my (@parts, $cnt);

    while ($data ~~ m:nth(++$cnt)/$<head>=[(\s*)    \N+\n  ]      # split off one level as 'head' (or terminal 'leaf')
                                  $<body>=[[$0  \s+ \N+\n]*]/ ) { # next sub-level is 'body' (defined by extra depth of indentation)

        my ($head, $body) = ($<head>, $<body>);
        $head ~~ /'|' $<weight>=[\S*] \s* '|' $<coverage>=[\S*]/; # save values of weight and coverage (if any) for later

        my ($w, $wsum) = (0, 0);
        $head ~= .[0],
        $w    += .[1],
        $wsum += .[1] * .[2]
            for walktree $body;

        my $weight   = (~$<weight>   or 1).fmt('%-8s');
        my $coverage = $w == 0
                    ?? (~$<coverage> or 0).fmt('%-10s')
                    !! ($wsum/$w)         .fmt('%-10.2g');
        @parts.push: [$head.subst(/'|' \N+/, "|$weight|$coverage|"), $weight, $coverage ];
    }
    return @parts;
}

(say .[0] for walktree $_) given

    q:to/END/
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
    END

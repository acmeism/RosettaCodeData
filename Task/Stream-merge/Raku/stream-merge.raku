sub merge_streams ( @streams ) {
    my @s = @streams.map({ hash( STREAM => $_, HEAD => .get ) })\
                    .grep({ .<HEAD>.defined });

    return gather while @s {
        my $h = @s.min: *.<HEAD>;
        take $h<HEAD>;
        $h<HEAD> := $h<STREAM>.get
            orelse @s .= grep( { $_ !=== $h } );
    }
}

say merge_streams([ @*ARGS».&open ]);

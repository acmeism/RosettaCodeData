my @sorted =
    map { $_->[0] }
    sort { $a->[1] cmp $b->[1] }
    map { [$_, eval "v$_"] }
    @OIDs;

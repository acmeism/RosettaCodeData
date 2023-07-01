sub cubLine ($$$$) {
    my ($n, $dx, $dy, $cde) = @_;

    printf '%*s', $n + 1, substr($cde, 0, 1);

    for (my $d = 9 * $dx - 1 ; $d > 0 ; --$d) {
        print substr($cde, 1, 1);
    }

    print substr($cde, 0, 1);
    printf "%*s\n", $dy + 1, substr($cde, 2, 1);
}

sub cuboid ($$$) {
    my ($dx, $dy, $dz) = @_;

    printf "cuboid %d %d %d:\n", $dx, $dy, $dz;
    cubLine $dy + 1, $dx, 0, '+-';

    for (my $i = 1 ; $i <= $dy ; ++$i) {
        cubLine $dy - $i + 1, $dx, $i - 1, '/ |';
    }
    cubLine 0, $dx, $dy, '+-|';

    for (my $i = 4 * $dz - $dy - 2 ; $i > 0 ; --$i) {
        cubLine 0, $dx, $dy, '| |';
    }
    cubLine 0, $dx, $dy, '| +';

    for (my $i = 1 ; $i <= $dy ; ++$i) {
        cubLine 0, $dx, $dy - $i, '| /';
    }
    cubLine 0, $dx, 0, "+-\n";
}

cuboid 2, 3, 4;
cuboid 1, 1, 1;
cuboid 6, 2, 1;

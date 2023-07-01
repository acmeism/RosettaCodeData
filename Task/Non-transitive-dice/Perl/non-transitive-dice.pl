use strict;
use warnings;

sub fourFaceCombs {
    my %found = ();
    my @res = ();
    for (my $i = 1; $i <= 4; $i++) {
        for (my $j = 1; $j <= 4; $j++) {
            for (my $k = 1; $k <= 4; $k++) {
                for (my $l = 1; $l <= 4; $l++) {
                    my @c = sort ($i, $j, $k, $l);
                    my $key = 0;
                    for my $p (@c) {
                        $key = 10 * $key + $p;
                    }
                    if (not exists $found{$key}) {
                        $found{$key} = 1;
                        push @res, \@c;
                    }
                }
            }
        }
    }
    return @res;
}

sub compare {
    my $xref = shift;
    my $yref = shift;

    my @x = @$xref;
    my $xw = 0;

    my @y = @$yref;
    my $yw = 0;

    for my $i (@x) {
        for my $j (@y) {
            if ($i < $j) {
                $yw++;
            }
            if ($j < $i) {
                $xw++;
            }
        }
    }

    if ($xw < $yw) {
        return -1;
    }
    if ($yw < $xw) {
        return 1;
    }
    return 0;
}

sub findIntransitive3 {
    my $dice_ref = shift;
    my @dice = @$dice_ref;
    my $len = scalar @dice;

    my @res = ();
    for (my $i = 0; $i < $len; $i++) {
        for (my $j = 0; $j < $len; $j++) {
            my $first = compare($dice[$i], $dice[$j]);
            if ($first == 1) {
                for (my $k = 0; $k < $len; $k++) {
                    my $second = compare($dice[$j], $dice[$k]);
                    if ($second == 1) {
                        my $third = compare($dice[$k], $dice[$i]);
                        if ($third == 1) {
                            my $d1r = $dice[$i];
                            my $d2r = $dice[$j];
                            my $d3r = $dice[$k];
                            my @itd = ($d1r, $d2r, $d3r);
                            push @res, \@itd;
                        }
                    }
                }
            }
        }
    }
    return @res;
}

sub findIntransitive4 {
    my $dice_ref = shift;
    my @dice = @$dice_ref;
    my $len = scalar @dice;

    my @res = ();
    for (my $i = 0; $i < $len; $i++) {
        for (my $j = 0; $j < $len; $j++) {
            for (my $k = 0; $k < $len; $k++) {
                for (my $l = 0; $l < $len; $l++) {
                    my $first = compare($dice[$i], $dice[$j]);
                    if ($first == 1) {
                        my $second = compare($dice[$j], $dice[$k]);
                        if ($second == 1) {
                            my $third = compare($dice[$k], $dice[$l]);
                            if ($third == 1) {
                                my $fourth = compare($dice[$l], $dice[$i]);
                                if ($fourth == 1) {
                                    my $d1r = $dice[$i];
                                    my $d2r = $dice[$j];
                                    my $d3r = $dice[$k];
                                    my $d4r = $dice[$l];
                                    my @itd = ($d1r, $d2r, $d3r, $d4r);
                                    push @res, \@itd;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return @res;
}

sub main {
    my @dice = fourFaceCombs();
    my $len = scalar @dice;
    print "Number of eligible 4-faced dice: $len\n\n";

    my @it3 = findIntransitive3(\@dice);
    my $count3 = scalar @it3;
    print "$count3 ordered lists of 3 non-transitive dice found, namely:\n";
    for my $itref (@it3) {
        print "[ ";
        for my $r (@$itref) {
            print "[@$r] ";
        }
        print "]\n";
    }
    print "\n";

    my @it4 = findIntransitive4(\@dice);
    my $count = scalar @it4;
    print "$count ordered lists of 4 non-transitive dice found, namely:\n";
    for my $itref (@it4) {
        print "[ ";
        for my $r (@$itref) {
            print "[@$r] ";
        }
        print "]\n";
    }
}

main();

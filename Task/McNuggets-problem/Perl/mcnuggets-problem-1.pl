use ntheory qw/forperm gcd vecmin/;

sub Mcnugget_number {
    my $counts = shift;

    return 'No maximum' if 1 < gcd @$counts;

    my $min = vecmin @$counts;
    my @meals;
    my @min;

    my $a = -1;
    while (1) {
        $a++;
        for my $b (0..$a) {
            for my $c (0..$b) {
                my @s = ($a, $b, $c);
                forperm {
                    $meals[
                        $s[$_[0]] * $counts->[0]
                      + $s[$_[1]] * $counts->[1]
                      + $s[$_[2]] * $counts->[2]
                    ] = 1;
                } @s;
            }
        }
        for my $i (0..$#meals) {
            next unless $meals[$i];
            if ($min[-1] and $i == ($min[-1] + 1)) {
                push @min, $i;
                last if $min == @min
            } else {
                @min = $i;
            }
        }
        last if $min == @min
    }
    $min[0] ? $min[0] - 1 : 0
}

for my $counts ([6,9,20], [6,7,20], [1,3,20], [10,5,18], [5,17,44], [2,4,6], [3,6,15]) {
    print 'Maximum non-Mcnugget number using ' . join(', ', @$counts) . ' is: ' . Mcnugget_number($counts) . "\n"
}

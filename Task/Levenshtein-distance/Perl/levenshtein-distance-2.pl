use List::Util qw(min);

sub leven {
    my ($s, $t) = @_;

    my $tl = length($t);
    my $sl = length($s);

    my @d = ([0 .. $tl], map { [$_] } 1 .. $sl);

    foreach my $i (0 .. $sl - 1) {
        foreach my $j (0 .. $tl - 1) {
            $d[$i + 1][$j + 1] =
              substr($s, $i, 1) eq substr($t, $j, 1)
              ? $d[$i][$j]
              : 1 + min($d[$i][$j + 1], $d[$i + 1][$j], $d[$i][$j]);
        }
    }

    $d[-1][-1];
}

print leven('rosettacode', 'raisethysword'), "\n";

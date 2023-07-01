my $N = 2200;
push @sq, $_**2 for 0 .. $N;
my @not = (0) x $N;
@not[0] = 1;


for my $d (1 .. $N) {
    my $last = 0;
    for my $a (reverse ceiling($d/3) .. $d) {
        for my $b (1 .. ceiling($a/2)) {
            my $ab = $sq[$a] + $sq[$b];
            last if $ab > $sq[$d];
            my $x = sqrt($sq[$d] - $ab);
            if ($x == int $x) {
                $not[$d] = 1;
                $last = 1;
                last
            }
        }
        last if $last;
    }
}

sub ceiling { int $_[0] + 1 - 1e-15 }

for (0 .. $#not) {
    $result .= "$_ " unless $not[$_]
}
print "$result\n"

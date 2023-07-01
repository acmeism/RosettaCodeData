my @lvl = [1];
my %p = (1 => 0);

sub path {
    my ($n) = @_;
    return () if ($n == 0);
    until (exists $p{$n}) {
        my @q;
        foreach my $x (@{$lvl[0]}) {
            foreach my $y (path($x)) {
                my $z = $x + $y;
                last if exists($p{$z});
                $p{$z} = $x;
                push @q, $z;
            }
        }
        $lvl[0] = \@q;
    }
    (path($p{$n}), $n);
}

sub tree_pow {
    my ($x, $n) = @_;
    my %r = (0 => 1, 1 => $x);
    my $p = 0;
    foreach my $i (path($n)) {
        $r{$i} = $r{$i - $p} * $r{$p};
        $p = $i;
    }
    $r{$n};
}

sub show_pow {
    my ($x, $n) = @_;
    my $fmt = "%d: %s\n" . ("%g^%s = %f", "%s^%s = %s")[$x == int($x)] . "\n";
    printf($fmt, $n, "(" . join(" ", path($n)) . ")", $x, $n, tree_pow($x, $n));
}

show_pow(2, $_) for 0 .. 17;
show_pow(1.1, 81);
{
    use bigint (try => 'GMP');
    show_pow(3, 191);
}

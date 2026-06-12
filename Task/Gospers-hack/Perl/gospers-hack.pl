sub gospers_hack($) {
    my ($x) = @_;
    my $c = $x & -$x;
    my $r = $x + $c;
    (($r ^ $x) >> 2) / $c | $r;
}

for (1, 3, 7, 15) {
    my @nexts = $_;
    push @nexts, gospers_hack($nexts[$#nexts]) for 1..10;
    print $_ . ': ' . join(', ', @nexts[1..$#nexts]) . "\n";
}

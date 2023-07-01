use ntheory qw/is_square_free moebius/;

sub square_free_count {
    my ($n) = @_;
    my $count = 0;
    foreach my $k (1 .. sqrt($n)) {
        $count += moebius($k) * int($n / $k**2);
    }
    return $count;
}

print "Square─free numbers between 1 and 145:\n";
print join(' ', grep { is_square_free($_) } 1 .. 145), "\n";

print "\nSquare-free numbers between 10^12 and 10^12 + 145:\n";
print join(' ', grep { is_square_free($_) } 1e12 .. 1e12 + 145), "\n";

print "\n";
foreach my $n (2 .. 6) {
    my $c = square_free_count(10**$n);
    print "The number of square-free numbers between 1 and 10^$n (inclusive) is: $c\n";
}

my $i;
sub sum {
    my (undef, $lo, $hi, $term) = @_;
    my $temp = 0;
    for ($_[0] = $lo; $_[0] <= $hi; $_[0]++) {
        $temp += $term->();
    }
    return $temp;
}

print sum($i, 1, 100, sub { 1 / $i }), "\n";

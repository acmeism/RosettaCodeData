my $i;
sub sum {
    my ($i, $lo, $hi, $term) = @_;
    my $temp = 0;
    for ($$i = $lo; $$i <= $hi; $$i++) {
        $temp += $term->();
    }
    return $temp;
}

print sum(\$i, 1, 100, sub { 1 / $i }), "\n";

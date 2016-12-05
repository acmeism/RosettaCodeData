sub mode (*@a) {
    my %counts := @a.Bag;
    my $max = %counts.values.max;
    return |%counts.grep(*.value == $max).map(*.key);
}

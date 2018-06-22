sub mode (*@a) {
    my %counts := @a.Bag;
    my $max = %counts.values.max;
    return |%counts.grep(*.value == $max).map(*.key);
}

# Testing with arrays:
say mode [1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17];
say mode [1, 1, 2, 4, 4];

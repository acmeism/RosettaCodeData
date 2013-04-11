sub mode (@a) {
    my %counts;
    ++%counts{$_} for @a;
    my $max = [max] values %counts;
    return map { .key }, grep { .value == $max }, %counts.pairs;
}

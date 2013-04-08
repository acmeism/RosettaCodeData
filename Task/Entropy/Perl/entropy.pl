sub entropy {
    my %count; $count{$_}++ for @_;
    my @p = map $_/@_, values %count;
    my $entropy = 0;
    $entropy += - $_ * log $_ for @p;
    $entropy / log 2
}

print entropy split //, "1223334444";

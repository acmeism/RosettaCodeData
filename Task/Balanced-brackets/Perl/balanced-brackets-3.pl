sub balanced {
    my $depth = 0;
    for (split //, shift) {
        if    ($_ eq '[') { ++$depth }
        elsif ($_ eq ']') { return if --$depth < 0 }
    }
    return !$depth
}

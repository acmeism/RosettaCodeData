sub leap {
    my $yr = $_[0];
    if ($yr % 100 == 0) {
        return ($yr % 400 == 0);
    }
    return ($yr % 4 == 0);
}

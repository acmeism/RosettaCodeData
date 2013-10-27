sub max {
    my $max = shift;
    for (@_) { $max = $_ if $_ > $max }
    return $max;
}

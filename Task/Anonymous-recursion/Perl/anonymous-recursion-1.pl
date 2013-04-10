sub recur (&@) {
    my $f = shift;
    local *recurse = $f;
    $f->(@_);
}

sub fibo {
    my $n = shift;
    $n < 0 and die 'Negative argument';
    recur {
        my $m = shift;
        $m < 3 ? 1 : recurse($m - 1) + recurse($m - 2);
    } $n;
}

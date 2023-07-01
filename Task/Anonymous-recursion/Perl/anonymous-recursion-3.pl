sub fibo {
    my $n = shift;
    $n < 0 and die 'Negative argument';
    no strict 'refs';
    $n < 3 ? 1 : (caller(0))[3]->($n - 1) + (caller(0))[3]->($n - 2);
}

use List::Util qw(sum);

sub perf {
    my $n = shift;
    $n == sum(0, grep {$n % $_ == 0} 1..$n-1);
}

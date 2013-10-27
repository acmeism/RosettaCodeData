sub one_of_n($n) {
    my $choice;
    $choice = $_ if .rand < 1 for 1 .. $n;
    $choice - 1;
}

sub one_of_n_test($n = 10, $trials = 1_000_000) {
    my @bins;
    @bins[one_of_n($n)]++ for ^$trials;
    @bins;
}

say one_of_n_test();

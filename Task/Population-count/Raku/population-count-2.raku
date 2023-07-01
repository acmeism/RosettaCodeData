sub population-count(Int $n is copy where * >= 0) {
    loop (my $c = 0; $n; $n +>= 1) {
        $c += $n +& 1;
    }
    $c;
}

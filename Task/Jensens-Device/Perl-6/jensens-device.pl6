sub sum($i is rw, $lo, $hi, &term) {
    my $temp = 0;
    loop ($i = $lo; $i <= $hi; $i++) {
        $temp += term;
    }
    return $temp;
}

my $i;
say sum $i, 1, 100, { 1 / $i };

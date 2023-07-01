sub binomial {
    use bigint;
    my ($r, $n, $k) = (1, @_);
    for (1 .. $k) { $r *= $n--; $r /= $_ }
    $r;
}

print binomial(5, 3);

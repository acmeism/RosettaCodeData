sub sum-mults($first, $limit) {
    (my $last = $limit - 1) -= $last % $first;
    ($last div $first) * ($first + $last) div 2;
}

sub sum35(\n) {
    sum-mults(3,n) + sum-mults(5,n) - sum-mults(15,n);
}

say sum35($_) for 1,10,100...10**30;

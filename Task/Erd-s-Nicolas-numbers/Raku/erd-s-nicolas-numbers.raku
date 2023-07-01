use Prime::Factor;

sub is-Erdős-Nicolas ($n) {
    my @divisors = $n.&proper-divisors: :s;
    ((@divisors.sum > $n) && (my $key = ([\+] @divisors).first: $n, :k)) ?? 1 + $key !! False
}

my $count;

(1..*).hyper(:2000batch).map( * × 2 ).map: {
    if my $key = .&is-Erdős-Nicolas {
        printf "%8d == sum of its first %3d divisors\n", $_, $key;
        exit if ++$count >= 8;
    }
}

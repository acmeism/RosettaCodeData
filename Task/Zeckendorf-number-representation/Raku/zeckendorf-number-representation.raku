printf "%2d: %8s\n", $_, zeckendorf($_) for 0 .. 20;

multi zeckendorf(0) { '0' }
multi zeckendorf($n is copy) {
    constant FIBS = (1,2, *+* ... *).cache;
    [~] map {
        $n -= $_ if my $digit = $n >= $_;
        +$digit;
    }, reverse FIBS ...^ * > $n;
}
